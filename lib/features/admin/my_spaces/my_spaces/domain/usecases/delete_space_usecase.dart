import '../repos/my_spaces_repo.dart';

class DeleteSpaceUseCase {
  final MySpacesRepo repo;
  const DeleteSpaceUseCase(this.repo);

  Future<void> call({required String spaceId}) => repo.deleteSpace(spaceId: spaceId);
}


