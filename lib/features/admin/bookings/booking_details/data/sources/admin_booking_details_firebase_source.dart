import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_booking_details_source.dart';
import '../models/booking_details_model.dart';

/// مصدر Firebase لتفاصيل الحجز — يقرأ من bookings ويجمع بيانات المستخدم
class AdminBookingDetailsFirebaseSource implements AdminBookingDetailsSource {
  final _db = FirebaseFirestore.instance;

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

    // جلب بيانات المستخدم من users collection
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

    final userName  = d['userName']  as String? ?? d['user_name']  as String? ?? d['guestName']  as String? ?? 'Unknown';
    final spaceName = d['spaceName'] as String? ?? d['space_name'] as String? ?? d['workspaceName'] as String? ?? 'Space';
    final spaceAddr = d['spaceAddress'] as String? ?? d['location_address'] as String? ?? '-';
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
      duration: _calcDuration(startTs, endTs),
      plan: plan,
      price: pricePerH > 0 ? '\$$pricePerH/hr' : '-',
      total: '\$$totalPrice',
      status: d['status'] as String? ?? 'pending',
    );
  }

  @override
  Future<void> confirmBooking({required String bookingId}) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'approved',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelBooking({required String bookingId, required String reason}) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'canceled',
      'cancelReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
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

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
