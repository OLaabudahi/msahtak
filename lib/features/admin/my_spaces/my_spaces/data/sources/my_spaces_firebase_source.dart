import 'package:Msahtak/features/admin/my_spaces/my_spaces/data/sources/my_spaces_source.dart';

import '../../../../../../core/services/firestore_api.dart';
import '../models/space_model.dart';

class MySpacesFirebaseSource implements MySpacesSource{
  final FirestoreApi api;

  MySpacesFirebaseSource(this.api);

  @override
  Future<List<SpaceModel>> fetchSpaces() async {
    final data = await api.getCollection(collection: 'spaces');

    return data.map((e) => SpaceModel.fromJson(e)).toList();
  }

  @override
  Future<void> hideSpace({required String spaceId}) async {
    final doc = await api.getDoc(collection: 'spaces', docId: spaceId);

    final current = doc?['isActive'] ?? true;

    await api.updateFields(
      collection: 'spaces',
      docId: spaceId,
      data: {'isActive': !current},
    );
  }

  @override
  Future<void> deleteSpace({required String spaceId}) async {
    await api.delete(collection: 'spaces', docId: spaceId);
  }
}


