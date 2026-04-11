import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_booking_details_source.dart';
import '../models/booking_details_model.dart';


class AdminBookingDetailsFirebaseSource implements AdminBookingDetailsSource {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Future<BookingDetailsModel> fetchBookingDetails({required String bookingId}) async {
    final doc = await _db.collection('bookings').doc(bookingId).get();
    if (!doc.exists) {
      return BookingDetailsModel(
        id: bookingId, bookingCode: bookingId,
        userName: 'Unknown', userAvatar: '?',
        userPhone: '-', userEmail: '-',
        space: '-', spaceAddress: '-',
        date: '-', time: '-', duration: '-',
        plan: '-', price: '-', total: '-', status: 'pending',
      );
    }
    final d = doc.data()!;


    final uid = d['userId'] as String? ?? d['user_id'] as String? ?? '';
    String userPhone = '-', userEmail = '-';
    if (uid.isNotEmpty) {
      final userDoc = await _db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final u = userDoc.data()!;
        userPhone = u['phoneNumber'] as String? ?? u['phone'] as String? ?? '-';
        userEmail = u['email'] as String? ?? '-';
      }
    }

    final startTs = d['startDate'] as Timestamp?;
    final endTs   = d['endDate']   as Timestamp?;
    final totalPrice = d['total_price'] ?? d['totalPrice'] ?? d['totalAmount'] ?? 0;
    final currency = (d['currency'] ?? '₪').toString();

    final userName  = d['userName']  as String? ?? d['user_name']  as String? ?? d['guestName']  as String? ?? 'Unknown';
    final spaceName = d['spaceName'] as String? ?? d['space_name'] as String? ?? d['workspaceName'] as String? ?? 'Space';
    String spaceAddr = d['spaceAddress'] as String? ?? d['location_address'] as String? ?? '-';
    final spaceId = (d['spaceId'] ?? d['space_id'] ?? '').toString();
    if (spaceAddr == '-' && spaceId.isNotEmpty) {
      final spaceDoc = await _db.collection('spaces').doc(spaceId).get();
      final s = spaceDoc.data() ?? <String, dynamic>{};
      spaceAddr = (s['address'] ?? s['location_address'] ?? '-').toString();
    }
    final plan      = d['plan'] as String? ?? d['bookingType'] as String? ?? 'Desk';
    final pricePerH = d['pricePerHour'] as num? ?? 0;

    return BookingDetailsModel(
      id: doc.id,
      bookingCode: 'BK-${doc.id.substring(0, 6).toUpperCase()}',
      userName: userName,
      userAvatar: _initials(userName),
      userPhone: userPhone,
      userEmail: userEmail,
      space: spaceName,
      spaceAddress: spaceAddr,
      date: _formatDate(startTs),
      time: _formatTimeRange(startTs, endTs),
      duration: _durationFromRequest(d, startTs, endTs),
      plan: plan,
      price: pricePerH > 0 ? '\$$pricePerH/hr' : '-',
      total: '$currency$totalPrice',
      status: d['status'] as String? ?? 'pending',
      paymentMethod: (d['paymentMethodName'] ?? d['paymentMethod'] ?? '-').toString(),
      paymentStatus: _statusLabel((d['status'] ?? '').toString()),
      paymentReceiptUrl: (d['paymentReceiptUrl'] ?? '').toString(),
      payerAccountHolder: (d['payerAccountHolder'] ?? '').toString(),
      payerTransferTime: (d['payerTransferTime'] ?? '').toString(),
      payerReferenceNumber: (d['payerReferenceNumber'] ?? '').toString(),
      cancelReason: (d['cancelReason'] ?? '').toString(),
      cancellationStage: (d['cancellationStage'] ?? '').toString(),
      cancelledBy: _readCancelledBy(d['cancelledBy']),
      cancelledAt: _formatDateTime(_toDate(d['cancelledAt'])),
    );
  }

  @override
  Future<void> confirmBooking({required String bookingId}) async {
    final current = await _db.collection('bookings').doc(bookingId).get();
    final status = (current.data()?['status'] ?? '').toString();
    final deadline = DateTime.now().add(const Duration(hours: 24));
    await _db.collection('bookings').doc(bookingId).update({
      'status': status == 'payment_under_review' ? 'confirmed' : 'approved_waiting_payment',
      'statusHint': status == 'payment_under_review'
          ? 'Booking confirmed after payment verification.'
          : 'Approved by space owner, waiting payment.',
      'paymentDeadline': status == 'payment_under_review' ? null : Timestamp.fromDate(deadline),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _createNotification(bookingId: bookingId, type: 'bookingApproved');
  }

  @override
  Future<void> cancelBooking({required String bookingId, required String reason}) async {
    final snap = await _db.collection('bookings').doc(bookingId).get();
    final prevStatus = (snap.data()?['status'] ?? '').toString();
    final stage = _resolveCancellationStage(prevStatus);
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'canceled',
      'cancelReason': reason,
      'cancellationStage': stage,
      'cancellationCompensation': stage == 'after_payment'
          ? 'Compensation status: pending review.'
          : '',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('cancellation_reason_suggestions').add({
      'reason': reason,
      'addedBy': _auth.currentUser?.uid ?? '',
      'addedByName': _auth.currentUser?.displayName ?? 'admin',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _createNotification(bookingId: bookingId, type: 'bookingRejected');
  }


  Future<void> _createNotification({
    required String bookingId,
    required String type,
  }) async {
    try {
      final doc = await _db.collection('bookings').doc(bookingId).get();
      if (!doc.exists) return;
      final d = doc.data()!;
      final uid = d['userId'] as String? ?? d['user_id'] as String? ?? '';
      if (uid.isEmpty) return;
      final spaceName = d['spaceName'] as String? ??
          d['space_name'] as String? ??
          d['workspaceName'] as String? ??
          'Space';
      final isApproved = type == 'bookingApproved';
      await _db.collection('notifications').add({
        'userId': uid,
        'title': isApproved ? 'Booking Approved' : 'Booking Rejected',
        'subtitle': isApproved
            ? 'Your booking for $spaceName has been approved. Proceed to payment.'
            : 'Your booking for $spaceName has been rejected.',
        'type': type,
        'requestId': bookingId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  String _formatDate(Timestamp? ts) {
    if (ts == null) return '-';
    final d = ts.toDate();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _formatTimeRange(Timestamp? start, Timestamp? end) {
    if (start == null) return '-';
    final timeStr = _hhmm(start.toDate());
    if (end == null) return timeStr;
    return '$timeStr - ${_hhmm(end.toDate())}';
  }

  String _hhmm(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  String _calcDuration(Timestamp? start, Timestamp? end) {
    if (start == null || end == null) return '-';
    final h = end.toDate().difference(start.toDate()).inHours;
    return h == 1 ? '1 hour' : '$h hours';
  }

  String _durationFromRequest(
    Map<String, dynamic> data,
    Timestamp? start,
    Timestamp? end,
  ) {
    final value = (data['durationValue'] as num?)?.toInt();
    final unit = (data['durationUnit'] ?? '').toString();
    if (value != null && value > 0 && unit.isNotEmpty) {
      final normalized = unit.endsWith('s') ? unit : '${unit}s';
      return '$value $normalized';
    }
    return _calcDuration(start, end);
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _resolveCancellationStage(String prevStatus) {
    if (prevStatus == 'approved_waiting_payment' || prevStatus == 'approved') {
      return 'before_payment';
    }
    if (prevStatus == 'payment_under_review' ||
        prevStatus == 'confirmed' ||
        prevStatus == 'paid') {
      return 'after_payment';
    }
    return 'owner_rejected';
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'payment_under_review':
        return 'Payment under review';
      case 'confirmed':
      case 'paid':
        return 'Confirmed';
      case 'approved_waiting_payment':
        return 'Awaiting payment';
      case 'canceled':
      case 'rejected':
        return 'Cancelled';
      default:
        return status.isEmpty ? '-' : status;
    }
  }

  DateTime? _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${dt.year} $hh:$mi';
  }

  String _readCancelledBy(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      return (value['name'] ?? value['role'] ?? '').toString();
    }
    return '';
  }
}
