import '../entities/space_management_entity.dart';

abstract class SpaceManagementRepo {
  Future<SpaceManagementEntity> getSpace({required String spaceId});
  Future<void> setHidden({required String spaceId, required bool hidden});
}


