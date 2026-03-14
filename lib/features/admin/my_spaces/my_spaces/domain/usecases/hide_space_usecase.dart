import '../repos/my_spaces_repo.dart';

class HideSpaceUseCase {
  final MySpacesRepo repo;
  const HideSpaceUseCase(this.repo);

  Future<void> call({required String spaceId}) => repo.hideSpace(spaceId: spaceId);
}
