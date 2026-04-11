import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firestore_api.dart';
import 'bookings_source.dart';

class BookingsFirebaseSource implements BookingsSource {
  final FirestoreApi api;

  BookingsFirebaseSource(this.api);

  @override
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return const [];

    final byUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'userId',
      value: uid,
      limit: 300,
    );

    final byLegacyUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'user_id',
      value: uid,
      limit: 300,
    );

    final merged = <String, Map<String, dynamic>>{};
    for (final row in [...byUserId, ...byLegacyUserId]) {
      final id = (row['id'] ?? '').toString();
      if (id.isEmpty) continue;

      final ownerA = (row['userId'] ?? '').toString();
      final ownerB = (row['user_id'] ?? '').toString();
      if (ownerA != uid && ownerB != uid) continue;

      merged[id] = row;
    }

    return merged.values.toList(growable: false);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': 'cancelled',
      },
    );
  }
}
