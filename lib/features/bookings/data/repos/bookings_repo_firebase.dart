/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';

/// âœ… طھظ†ظپظٹط° Firebase ظ„ظ€ BookingsRepo â€“ ظٹظ‚ط±ط£ bookings ظ…ط±طھط¨ط·ط© ط¨ط§ظ„ظ…ط³طھط®ط¯ظ…
class BookingsRepoFirebase implements BookingsRepo {
  @override
  Future<List<Booking>> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    // ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ userId (camelCase) طŒ ط§ظ„طھط·ط¨ظٹظ‚ ط§ظ„ظ‚ط¯ظٹظ… ظƒط§ظ† user_id
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .get();
    } catch (_) {
      snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user_id', isEqualTo: uid)
          .get();
    }

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snap.docs;

    // ط¥ط°ط§ ظ„ظ… ظ†ط¬ط¯ ط¨ظ€ userId ظ†ط¬ط±ط¨ user_id
    if (docs.isEmpty) {
      try {
        final snap2 = await FirebaseFirestore.instance
            .collection('bookings')
            .where('user_id', isEqualTo: uid)
            .get();
        docs = snap2.docs;
      } catch (_) {}
    }

    docs.sort((a, b) {
      // ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ createdAt طŒ ط§ظ„طھط·ط¨ظٹظ‚ ط§ظ„ظ‚ط¯ظٹظ… created_at
      final aTs = a.data()['createdAt'] ?? a.data()['created_at'];
      final bTs = b.data()['createdAt'] ?? b.data()['created_at'];
      if (aTs is Timestamp && bTs is Timestamp) return bTs.compareTo(aTs);
      return 0;
    });

    // ط¬ظ…ط¹ ظƒظ„ spaceIds ط§ظ„ظپط±ظٹط¯ط© ظ„ط¬ظ„ط¨ طµظˆط± ط§ظ„ط£ظ…ط§ظƒظ†
    final spaceIds = docs
        .map((doc) {
          final d = doc.data();
          return d['space_id'] as String? ??
              d['spaceId'] as String? ??
              d['workspaceId'] as String? ??
              '';
        })
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    // ط¬ظ„ط¨ طµظˆط± ط§ظ„ط£ظ…ط§ظƒظ† ظ…ظ† workspaces ظˆ spaces
    final Map<String, String> spaceImages = {};
    if (spaceIds.isNotEmpty) {
      final futures = await Future.wait([
        ...spaceIds.map((id) => FirebaseFirestore.instance.collection('workspaces').doc(id).get()),
        ...spaceIds.map((id) => FirebaseFirestore.instance.collection('spaces').doc(id).get()),
      ]);
      for (final snap in futures) {
        if (!snap.exists) continue;
        final d = snap.data()!;
        final imagesList = (d['images'] as List?)?.cast<String>() ?? const [];
        final url = imagesList.isNotEmpty
            ? imagesList.first
            : (d['imageUrl'] as String? ??
                d['cover'] as String? ??
                d['thumbnailUrl'] as String? ??
                '');
        if (url.isNotEmpty) spaceImages[snap.id] = url;
      }
    }

    return docs.map((doc) {
      final d = doc.data();

      // ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ workspaceId طŒ ط§ظ„طھط·ط¨ظٹظ‚ ط§ظ„ظ‚ط¯ظٹظ… space_id
      final spaceId = d['space_id'] as String? ??
          d['spaceId'] as String? ??
          d['workspaceId'] as String? ??
          '';

      // ط§ظ„ط£ط¯ظ…ظ† ظ„ط§ ظٹظƒطھط¨ space_name â€“ ظ†ط³طھط®ط¯ظ… workspaceId ظƒظ€ fallback
      final spaceName = d['space_name'] as String? ??
          d['spaceName'] as String? ??
          d['workspaceName'] as String? ??
          'Space';

      // ط§ظ„طھط§ط±ظٹط®: ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ startDate ظƒظ€ Timestamp
      final startTs = d['startDate'] as Timestamp? ?? d['date'] as Timestamp?;
      final dateText = d['date_text'] as String? ??
          d['date'] as String? ??
          (startTs != null
              ? '${startTs.toDate().day}/${startTs.toDate().month}/${startTs.toDate().year}'
              : '--');

      final endTs = d['endDate'] as Timestamp?;
      final timeText = d['time_text'] as String? ??
          d['time_slot'] as String? ??
          (startTs != null && endTs != null
              ? '${_fmt(startTs.toDate())} â€“ ${_fmt(endTs.toDate())}'
              : '--');

      // ط§ظ„ط³ط¹ط±: ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ totalAmount
      final totalPrice = (d['total_price'] as num?)?.toDouble() ??
          (d['totalPrice'] as num?)?.toDouble() ??
          (d['totalAmount'] as num?)?.toDouble() ??
          0.0;

      // ط§ظ„طµظˆط±ط©: ظ…ظ† ط§ظ„ط­ط¬ط² ط£ظˆظ„ط§ظ‹طŒ ط«ظ… ظ…ظ† ط¨ظٹط§ظ†ط§طھ ط§ظ„ظ…ظƒط§ظ†
      final imageUrl = d['image_url'] as String? ??
          d['imageUrl'] as String? ??
          spaceImages[spaceId];

      return Booking(
        bookingId: doc.id,
        spaceId: spaceId,
        spaceName: spaceName,
        dateText: dateText,
        timeText: timeText,
        status: _normalizeStatus(d['status'] as String?),
        totalPrice: totalPrice,
        currency: d['currency'] as String? ?? 'â‚ھ',
        imageUrl: imageUrl,
      );
    }).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  /// طھط­ظˆظٹظ„ ط­ط§ظ„ط§طھ Firebase ط¥ظ„ظ‰ ط§ظ„ظ‚ظٹظ… ط§ظ„ظ…طھظˆظ‚ط¹ط© ظپظٹ ط§ظ„طھط·ط¨ظٹظ‚
  String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return 'confirmed';
      case 'pending':
      case 'under_review':
        return 'upcoming';
      case 'rejected':
      case 'denied':
      case 'cancelled':
        return 'cancelled';
      case 'completed':
        return 'completed';
      default:
        return 'upcoming';
    }
  }
}
*/


