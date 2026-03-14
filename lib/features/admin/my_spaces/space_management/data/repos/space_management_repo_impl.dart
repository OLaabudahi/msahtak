import '../../domain/entities/space_management_entity.dart';
import '../../domain/repos/space_management_repo.dart';
import '../sources/space_management_source.dart';

class SpaceManagementRepoImpl implements SpaceManagementRepo {
  final SpaceManagementSource source;
  const SpaceManagementRepoImpl(this.source);

  @override
  Future<SpaceManagementEntity> getSpace({required String spaceId}) async {
    final m = await source.fetchSpace(spaceId: spaceId);
    return m.toEntity();
  }

  @override
  Future<void> setHidden({required String spaceId, required bool hidden}) => source.setHidden(spaceId: spaceId, hidden: hidden);
}
