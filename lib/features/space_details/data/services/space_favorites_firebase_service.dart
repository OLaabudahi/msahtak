import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpaceFavoritesFirebaseService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SpaceFavoritesFirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  String? get currentUserId => auth.currentUser?.uid;

  Future<void> addFavorite({
    required String spaceId,
    required Map<String, dynamic> payload,
  }) async {
    final uid = currentUserId;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(spaceId)
        .set({
      ...payload,
      'spaceId': spaceId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFavorite(String spaceId) async {
    final uid = currentUserId;
    if (uid == null) {
      throw StateError('User not logged in');
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(spaceId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final uid = currentUserId;
    if (uid == null) return const [];

    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    return snap.docs
        .map((doc) => {
              ...doc.data(),
              'spaceId': doc.id,
            })
        .toList(growable: false);
  }
}
