import '../../../../core/services/firestore_api.dart';

abstract class HomeSource {
  Future<List<Map<String, dynamic>>> fetchSpaces();
}

class HomeFirebaseSource implements HomeSource {
  final FirestoreApi api;

  HomeFirebaseSource(this.api);

  @override
  Future<List<Map<String, dynamic>>> fetchSpaces() {
    return api.getCollection(collection: 'spaces');
  }
}
