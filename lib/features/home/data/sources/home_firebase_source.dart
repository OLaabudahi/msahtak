import '../../../../core/services/firestore_api.dart';

class HomeFirebaseSource {
  final FirestoreApi api = FirestoreApi();

  Future<List<Map<String, dynamic>>> fetchSpaces() {
    return api.getCollection(collection: 'spaces');
  }
}

