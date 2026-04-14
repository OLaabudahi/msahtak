import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileUsageFirebaseService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileUsageFirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return const [];

    final byUserId = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .get();

    final byLegacyUserId = await firestore
        .collection('bookings')
        .where('user_id', isEqualTo: uid)
        .get();

    final merged = <String, Map<String, dynamic>>{};

    for (final doc in [...byUserId.docs, ...byLegacyUserId.docs]) {
      merged[doc.id] = {...doc.data(), 'id': doc.id};
    }

    return merged.values.toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> getSpacesByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];

    final results = await Future.wait(
      ids.map((id) => firestore.collection('spaces').doc(id).get()),
    );

    return results
        .where((doc) => doc.exists)
        .map((doc) => {...?doc.data(), 'id': doc.id})
        .toList(growable: false);
  }
}
