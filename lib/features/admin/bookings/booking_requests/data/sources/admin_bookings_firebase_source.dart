import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_bookings_source.dart';
import '../models/booking_request_model.dart';
import '../../../../_shared/admin_session.dart';

/// ظ…طµط¯ط± Firebase ظ„ط·ظ„ط¨ط§طھ ط§ظ„ط­ط¬ط² â€” ظٹظ‚ط±ط£ ظ…ظ† ظ…ط¬ظ…ظˆط¹ط© bookings
class AdminBookingsFirebaseSource implements AdminBookingsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<BookingRequestModel>> fetchBookings({required String status}) async {
    // ظƒظ„ طھط§ط¨ ظٹط´ظ…ظ„ ط­ط§ظ„ط§طھ ظ…طھط¹ط¯ط¯ط©
    final List<String> statuses = switch (status) {
      'pending' => ['pending', 'under_review'],
      'approved' => ['approved', 'approved_waiting_payment', 'payment_under_review', 'confirmed'],
      'canceled' => ['canceled', 'rejected', 'expired'],
      _ => [status],
    };

    final assigned = AdminSession.assignedSpaceIds;

    final snaps = await Future.wait(
      statuses.map((s) => _db.collection('bookings').where('status', isEqualTo: s).get()),
    );
    final allDocs = snaps.expand((s) => s.docs).where((doc) {
      if (assigned.isEmpty) return true;
      final d = doc.data();
      final spaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
      return assigned.contains(spaceId);
    }).toList();

    final sorted = allDocs
      ..sort((a, b) {
        final at = (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final bt = (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });
    // ط¬ظ…ط¹ workspaceIds ط§ظ„ظپط±ظٹط¯ط© ظ„ط¬ظ„ط¨ ط¨ظٹط§ظ†ط§طھ ط§ظ„ظ…ظ‚ط§ط¹ط¯ ط¯ظپط¹ط©ظ‹ ظˆط§ط­ط¯ط©
    final spaceIds = sorted
        .map((doc) {
          final d = doc.data();
          return (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
        })
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> workspaceData = {};
    if (spaceIds.isNotEmpty) {
      final wsFutures = spaceIds.map((id) => _db.collection('spaces').doc(id).get());
      final wsDocs = await Future.wait(wsFutures);
      for (final wsDoc in wsDocs) {
        if (wsDoc.exists) workspaceData[wsDoc.id] = wsDoc.data()!;
      }
    }

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
      final spaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
      final ws = workspaceData[spaceId] ?? {};
      final totalSeats = (ws['totalSeats'] as num?)?.toInt() ?? 0;
      final availableSeats = (ws['availableSeats'] as num?)?.toInt() ?? totalSeats;

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
        spaceId: spaceId,
        totalSeats: totalSeats,
        availableSeats: availableSeats,
      );
    }).toList();
  }

  @override
  Future<void> acceptBooking({required String bookingId}) async {
    final deadline = DateTime.now().add(const Duration(hours: 24));
    final bookingRef = _db.collection('bookings').doc(bookingId);

    // ط­ظ…ط§ظٹط© ظ…ظ† ط§ظ„ظ…ظˆط§ظپظ‚ط© ط§ظ„ظ…ط²ط¯ظˆط¬ط© â€” ظ†طھط­ظ‚ظ‚ ظ…ظ† ط§ظ„ط­ط§ظ„ط© ط¯ط§ط®ظ„ Transaction
    bool alreadyProcessed = false;
    String spaceId = '';

    await _db.runTransaction((tx) async {
      final snap = await tx.get(bookingRef);
      if (!snap.exists) { alreadyProcessed = true; return; }
      final currentStatus = (snap.data()!['status'] ?? '') as String;
      // ط¥ط°ط§ ظƒط§ظ†طھ ط§ظ„ط­ط§ظ„ط© ظ„ظٹط³طھ pending ط£ظˆ under_review ظپط§ظ„ط­ط¬ط² ظ…ط¹ط§ظ„ظژط¬ ظ…ط³ط¨ظ‚ط§ظ‹
      if (currentStatus != 'pending' && currentStatus != 'under_review') {
        alreadyProcessed = true;
        return;
      }
      spaceId = (snap.data()!['workspaceId'] ?? snap.data()!['spaceId'] ?? snap.data()!['space_id'] ?? '') as String;
      tx.update(bookingRef, {
        'status': 'approved_waiting_payment',
        'paymentDeadline': Timestamp.fromDate(deadline),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    if (alreadyProcessed) return;

    // طھط®ظپظٹط¶ ط§ظ„ظ…ظ‚ط§ط¹ط¯ ط§ظ„ظ…طھط§ط­ط© ظپظٹ ط§ظ„ظ…ط³ط§ط­ط©
    if (spaceId.isNotEmpty) {
      try {
        final wsRef = _db.collection('spaces').doc(spaceId);
        await _db.runTransaction((tx) async {
          final wsSnap = await tx.get(wsRef);
          if (!wsSnap.exists) return;
          final current = (wsSnap.data()!['availableSeats'] as num?)?.toInt() ?? 0;
          tx.update(wsRef, {'availableSeats': current > 0 ? current - 1 : 0});
        });
      } catch (_) {}
    }

    await _createNotification(bookingId: bookingId, type: 'bookingApproved');
  }

  @override
  Future<void> rejectBooking({required String bookingId}) async {
    final bookingRef = _db.collection('bookings').doc(bookingId);

    // طھط­ظ‚ظ‚ ظ…ظ† ط§ظ„ط­ط§ظ„ط© ظ‚ط¨ظ„ ط§ظ„ط±ظپط¶ â€” ط¥ط°ط§ ظƒط§ظ† ظ…ظˆط§ظپظ‚ط§ظ‹ ط¹ظ„ظٹظ‡ ظ†ظڈط¹ظٹط¯ ط§ظ„ظ…ظ‚ط¹ط¯
    String prevStatus = '';
    String spaceId = '';
    try {
      final snap = await bookingRef.get();
      if (snap.exists) {
        final d = snap.data()!;
        prevStatus = (d['status'] ?? '') as String;
        spaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
      }
    } catch (_) {}

    await bookingRef.update({
      'status': 'canceled',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ط¥ط¹ط§ط¯ط© ط§ظ„ظ…ظ‚ط¹ط¯ ط¥ط°ط§ ظƒط§ظ† ظ‚ط¯ طھظ… ظ‚ط¨ظˆظ„ ط§ظ„ط­ط¬ط² ظ…ط³ط¨ظ‚ط§ظ‹
    if (spaceId.isNotEmpty && (prevStatus == 'approved_waiting_payment' || prevStatus == 'approved' || prevStatus == 'payment_under_review')) {
      try {
        final wsRef = _db.collection('spaces').doc(spaceId);
        await _db.runTransaction((tx) async {
          final wsSnap = await tx.get(wsRef);
          if (!wsSnap.exists) return;
          final current = (wsSnap.data()!['availableSeats'] as num?)?.toInt() ?? 0;
          final total = (wsSnap.data()!['totalSeats'] as num?)?.toInt() ?? 0;
          tx.update(wsRef, {'availableSeats': total > 0 ? (current + 1).clamp(0, total) : current + 1});
        });
      } catch (_) {}
    }

    await _createNotification(bookingId: bookingId, type: 'bookingRejected');
  }

  /// ظٹظ†ط´ط¦ ط¥ط´ط¹ط§ط±ط§ظ‹ ظپظٹ ظ…ط¬ظ…ظˆط¹ط© notifications ظ„ظ„ظٹظˆط²ط± طµط§ط­ط¨ ط§ظ„ط­ط¬ط²
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


