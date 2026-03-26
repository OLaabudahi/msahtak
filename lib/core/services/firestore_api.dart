import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// CREATE
  Future<void> create({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).set(data);
  }

  /// UPDATE
  Future<void> updateFields({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  /// DELETE ✅ (مهم جداً)
  Future<void> delete({
    required String collection,
    required String docId,
  }) async {
    await _db.collection(collection).doc(docId).delete();
  }

  /// GET DOC
  Future<Map<String, dynamic>?> getDoc({
    required String collection,
    required String docId,
  }) async {
    final doc = await _db.collection(collection).doc(docId).get();
    if (!doc.exists) return null;

    return {
      ...doc.data()!,
      "id": doc.id,
    };
  }

  /// GET COLLECTION (مهم للـ spaces)
  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
  }) async {
    final snapshot = await _db.collection(collection).get();

    return snapshot.docs.map((doc) {
      return {
        ...doc.data(),
        "id": doc.id,
      };
    }).toList();
  }

  /// QUERY
  Future<List<Map<String, dynamic>>> queryWhere({
    required String collection,
    required String field,
    required dynamic value,
  }) async {
    final snapshot =
    await _db.collection(collection).where(field, isEqualTo: value).get();

    return snapshot.docs.map((doc) {
      return {
        ...doc.data(),
        "id": doc.id,
      };
    }).toList();
  }

  /// STREAM
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collection,
  }) {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          ...doc.data(),
          "id": doc.id,
        };
      }).toList();
    });
  }
}