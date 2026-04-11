import '../../domain/entities/space_request_entity.dart';
import '../../domain/repos/space_request_repo.dart';
import '../models/space_request_model.dart';
import '../sources/space_request_firebase_source.dart';

class SpaceRequestRepoImpl implements SpaceRequestRepo {
  final SpaceRequestFirebaseSource source;

  SpaceRequestRepoImpl(this.source);

  @override
  Future<void> submitRequest(SpaceRequestEntity request) async {
    final model = SpaceRequestModel.fromEntity(request);
    await source.submitRequest(model);
  }
}
