import '../entities/space_management_entity.dart';
import '../repos/space_management_repo.dart';

class GetSpaceManagementUseCase {
  final SpaceManagementRepo repo;
  const GetSpaceManagementUseCase(this.repo);

  Future<SpaceManagementEntity> call({required String spaceId}) => repo.getSpace(spaceId: spaceId);
}


