import '../repos/space_management_repo.dart';

class SetSpaceHiddenUseCase {
  final SpaceManagementRepo repo;
  const SetSpaceHiddenUseCase(this.repo);

  Future<void> call({required String spaceId, required bool hidden}) => repo.setHidden(spaceId: spaceId, hidden: hidden);
}
