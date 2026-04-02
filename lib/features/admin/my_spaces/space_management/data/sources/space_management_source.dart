import '../models/space_management_model.dart';

abstract class SpaceManagementSource {
  Future<SpaceManagementModel> fetchSpace({required String spaceId});
  Future<void> setHidden({required String spaceId, required bool hidden});
}


