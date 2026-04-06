import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../../../../core/services/firestore_api.dart';
import '../../../../../../services/local_storage_service.dart';
import 'admin_bookings_source.dart';
import '../models/booking_request_model.dart';

class AdminBookingsFirebaseSource implements AdminBookingsSource {
  final FirestoreApi _api = FirestoreApi();
  final LocalStorageService _storage = LocalStorageService();

  @override
  Future<List<BookingRequestModel>> fetchBookings({required String status}) async {
    final adminId = await _storage.getUserId();

    final List<String> statuses = switch (status) {
      'pending' => ['pending', 'under_review'],
      'approved' => ['approved', 'approved_waiting_payment', 'payment_under_review', 'confirmed'],
      'canceled' => ['canceled', 'rejected', 'expired'],
      _ => [status],
    };

    /// =========================
    /// 1. جيب كل الحجوزات
    /// =========================
    final allBookings = await _api.getCollection(collection: 'bookings');

    /// =========================
    /// 2. فلترة حسب status + adminId
    /// =========================
    final filtered = allBookings.where((b) {
      final bookingStatus = b['status'] ?? '';

      if (!statuses.contains(bookingStatus)) return false;

      final space = b['space'] as Map<String, dynamic>? ?? {};
      final bookingAdminId = space['adminId'] ?? '';

      return bookingAdminId == adminId;
    }).toList();

    /// =========================
    /// 3. ترتيب حسب createdAt
    /// =========================
    filtered.sort((a, b) {
      final at = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bt = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bt.compareTo(at);
    });

    /// =========================
    /// 4. تجهيز بيانات المساحات
    /// =========================
    final spaceIds = filtered
        .map((b) => b['spaceId'] ?? '')
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> workspaceData = {};

    for (final id in spaceIds) {
      final doc = await _api.getDoc(collection: 'spaces', docId: id);
      if (doc != null) workspaceData[id] = doc;
    }

    /// =========================
    /// 5. تحويل لمودل
    /// =========================
    return filtered.map((d) {
      final startTs = d['startDate'] as Timestamp?;
      final endTs = d['endDate'] as Timestamp?;

      final userName =
          d['userName'] ??
              d['user_name'] ??
              d['guestName'] ??
              'Unknown';

      final spaceName =
          d['spaceName'] ??
              d['space_name'] ??
              d['workspaceName'] ??
              'Space';

      final plan =
          d['plan'] ??
              d['bookingType'] ??
              d['type'] ??
              'Desk';

      final spaceId = d['spaceId'] ?? '';

      final ws = workspaceData[spaceId] ?? {};
      final totalSeats = (ws['totalSeats'] as num?)?.toInt() ?? 0;
      final availableSeats =
          (ws['availableSeats'] as num?)?.toInt() ?? totalSeats;

      return BookingRequestModel(
        id: d['id'],
        userName: userName,
        userAvatar: _initials(userName),
        date: _formatDate(startTs),
        time: _formatTimeRange(startTs, endTs),
        duration: _calcDuration(startTs, endTs),
        plan: plan,
        space: spaceName,
        status: d['status'],
        spaceId: spaceId,
        totalSeats: totalSeats,
        availableSeats: availableSeats,
      );
    }).toList();
  }

  @override
  Future<void> acceptBooking({required String bookingId}) async {
    final deadline = DateTime.now().add(const Duration(hours: 24));

    final booking = await _api.getDoc(
      collection: 'bookings',
      docId: bookingId,
    );

    if (booking == null) return;

    final currentStatus = booking['status'] ?? '';

    if (currentStatus != 'pending' &&
        currentStatus != 'under_review') return;

    final spaceId =
        booking['workspaceId'] ??
            booking['spaceId'] ??
            booking['space_id'] ??
            '';

    await _api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': 'approved_waiting_payment',
        'paymentDeadline': Timestamp.fromDate(deadline),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    /// تقليل المقاعد
    if (spaceId.isNotEmpty) {
      final space = await _api.getDoc(
        collection: 'spaces',
        docId: spaceId,
      );

      if (space != null) {
        final current = (space['availableSeats'] as num?)?.toInt() ?? 0;

        await _api.updateFields(
          collection: 'spaces',
          docId: spaceId,
          data: {
            'availableSeats': current > 0 ? current - 1 : 0,
          },
        );
      }
    }

    await _createNotification(
      bookingId: bookingId,
      type: 'bookingApproved',
    );
  }

  @override
  Future<void> rejectBooking({required String bookingId}) async {
    final booking = await _api.getDoc(
      collection: 'bookings',
      docId: bookingId,
    );

    if (booking == null) return;

    final prevStatus = booking['status'] ?? '';
    final spaceId =
        booking['spaceId'] ??
            booking['space_id'] ??
            '';

    await _api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': 'canceled',
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    /// إعادة المقعد
    if (spaceId.isNotEmpty &&
        (prevStatus == 'approved_waiting_payment' ||
            prevStatus == 'approved' ||
            prevStatus == 'payment_under_review')) {
      final space = await _api.getDoc(
        collection: 'spaces',
        docId: spaceId,
      );

      if (space != null) {
        final current =
            (space['availableSeats'] as num?)?.toInt() ?? 0;
        final total =
            (space['totalSeats'] as num?)?.toInt() ?? 0;

        await _api.updateFields(
          collection: 'spaces',
          docId: spaceId,
          data: {
            'availableSeats':
            total > 0 ? (current + 1).clamp(0, total) : current + 1,
          },
        );
      }
    }

    await _createNotification(
      bookingId: bookingId,
      type: 'bookingRejected',
    );
  }

  /// =========================
  /// Notifications
  /// =========================
  Future<void> _createNotification({
    required String bookingId,
    required String type,
  }) async {
    final booking = await _api.getDoc(
      collection: 'bookings',
      docId: bookingId,
    );

    if (booking == null) return;

    final uid =
        booking['userId'] ??
            booking['user_id'] ??
            '';

    if (uid.isEmpty) return;

    final spaceName =
        booking['spaceName'] ??
            booking['workspaceName'] ??
            'Space';

    final isApproved = type == 'bookingApproved';

    await FirebaseFirestore.instance.collection('notifications').add({
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
  }

  /// =========================
  /// Helpers
  /// =========================
  String _formatDate(Timestamp? ts) {
    if (ts == null) return '-';
    final d = ts.toDate();
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
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
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_bookings_source.dart';
import '../models/booking_request_model.dart';
import '../../../../_shared/admin_session.dart';


class AdminBookingsFirebaseSource implements AdminBookingsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<BookingRequestModel>> fetchBookings({required String status}) async {

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
      final spaceId = (  d['spaceId'] ?? d['space_id'] ?? '') as String;
      return assigned.contains(spaceId);
    }).toList();

    final sorted = allDocs
      ..sort((a, b) {
        final at = (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final bt = (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return bt.compareTo(at);
      });

    final spaceIds = sorted
        .map((doc) {
          final d = doc.data();
          return (  d['spaceId'] ?? d['space_id'] ?? '') as String;
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
      final spaceId = (  d['spaceId'] ?? d['space_id'] ?? '') as String;
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


    bool alreadyProcessed = false;
    String spaceId = '';

    await _db.runTransaction((tx) async {
      final snap = await tx.get(bookingRef);
      if (!snap.exists) { alreadyProcessed = true; return; }
      final currentStatus = (snap.data()!['status'] ?? '') as String;

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

    // تخفيض المقاعد المتاحة في المساحة
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

    // تحقق من الحالة قبل الرفض — إذا كان موافقاً عليه نُعيد المقعد
    String prevStatus = '';
    String spaceId = '';
    try {
      final snap = await bookingRef.get();
      if (snap.exists) {
        final d = snap.data()!;
        prevStatus = (d['status'] ?? '') as String;
        spaceId = (  d['spaceId'] ?? d['space_id'] ?? '') as String;
      }
    } catch (_) {}

    await bookingRef.update({
      'status': 'canceled',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // إعادة المقعد إذا كان قد تم قبول الحجز مسبقاً
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

  /// ينشئ إشعاراً في مجموعة notifications لليوزر صاحب الحجز
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
*/
