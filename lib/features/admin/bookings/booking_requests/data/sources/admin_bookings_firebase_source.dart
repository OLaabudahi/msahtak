import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_bookings_source.dart';
import '../models/booking_request_model.dart';

/// مصدر Firebase لطلبات الحجز — يقرأ من مجموعة bookings
class AdminBookingsFirebaseSource implements AdminBookingsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<BookingRequestModel>> fetchBookings({required String status}) async {
    // pending tab يشمل 'pending' و 'under_review'
    final List<String> statuses = status == 'pending'
        ? ['pending', 'under_review']
        : [status];

    final snaps = await Future.wait(
      statuses.map((s) => _db.collection('bookings').where('status', isEqualTo: s).get()),
    );
    final allDocs = snaps.expand((s) => s.docs).toList();

    final sorted = allDocs
      ..sort((a, b) {
        final at = (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final bt = (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });
    return sorted.map((doc) {
      final d = doc.data();
      final startTs = d['startDate'] as Timestamp?;
      final endTs = d['endDate'] as Timestamp?;
      final dateText = _formatDate(startTs);
      final timeText = _formatTimeRange(startTs, endTs);
      final durationText = _calcDuration(startTs, endTs);

      final userName = d['userName'] as String? ??
          d['user_name'] as String? ??
          d['guestName'] as String? ??
          'Unknown';
      final initials = _initials(userName);
      final spaceName = d['spaceName'] as String? ??
          d['space_name'] as String? ??
          d['workspaceName'] as String? ??
          'Space';
      final plan = d['plan'] as String? ??
          d['bookingType'] as String? ??
          d['type'] as String? ??
          'Desk';

      return BookingRequestModel(
        id: doc.id,
        userName: userName,
        userAvatar: initials,
        date: dateText,
        time: timeText,
        duration: durationText,
        plan: plan,
        space: spaceName,
        status: status,
      );
    }).toList();
  }

  @override
  Future<void> acceptBooking({required String bookingId}) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'approved',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> rejectBooking({required String bookingId}) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'canceled',
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
    final s = start.toDate();
    final timeStr = _hhmm(s);
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
    final diff = end.toDate().difference(start.toDate());
    final h = diff.inHours;
    return h == 1 ? '1 hour' : '$h hours';
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
