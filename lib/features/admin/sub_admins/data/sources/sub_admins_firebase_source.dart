

import '../../../../../core/services/firestore_api.dart';
import '../../../../../services/local_storage_service.dart';

class SubAdminsFirebaseSource {
  final FirestoreApi _api = FirestoreApi();
  final LocalStorageService _storage = LocalStorageService();

  Future<List<Map<String, dynamic>>> fetchSpaces() async {
    final adminId = await _storage.getUserId();

    final spaces = await _api.getCollection(collection: 'spaces');

    return spaces.where((s) {
      final ownerId = s['adminId'] ?? s['ownerId'] ?? '';
      return ownerId == adminId;
    }).toList();
  }
}