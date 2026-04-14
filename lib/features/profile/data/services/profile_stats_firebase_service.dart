import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileStatsFirebaseService {
  final FirebaseFirestore firestore;

  ProfileStatsFirebaseService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, int>> fetchProfileStats(String uid) async {
    final bookingsByUserId = firestore
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .get();
    final bookingsByLegacyUserId = firestore
        .collection('bookings')
        .where('user_id', isEqualTo: uid)
        .get();
    final reviewsByUserId = firestore
        .collection('reviews')
        .where('userId', isEqualTo: uid)
        .get();
    final reviewsByLegacyUserId = firestore
        .collection('reviews')
        .where('user_id', isEqualTo: uid)
        .get();
    final favoritesSnap = firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    final results = await Future.wait([
      bookingsByUserId,
      bookingsByLegacyUserId,
      reviewsByUserId,
      reviewsByLegacyUserId,
      favoritesSnap,
    ]);

    final bookingIds = <String>{
      ...((results[0] as QuerySnapshot<Map<String, dynamic>>).docs)
          .map((doc) => doc.id),
      ...((results[1] as QuerySnapshot<Map<String, dynamic>>).docs)
          .map((doc) => doc.id),
    };

    final reviewIds = <String>{
      ...((results[2] as QuerySnapshot<Map<String, dynamic>>).docs)
          .map((doc) => doc.id),
      ...((results[3] as QuerySnapshot<Map<String, dynamic>>).docs)
          .map((doc) => doc.id),
    };

    final favoritesCount =
        (results[4] as QuerySnapshot<Map<String, dynamic>>).docs.length;

    return {
      'totalBookings': bookingIds.length,
      'completedBookings': reviewIds.length,
      'savedSpaces': favoritesCount,
    };
  }
}
