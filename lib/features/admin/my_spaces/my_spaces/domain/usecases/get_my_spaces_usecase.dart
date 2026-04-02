import '../entities/space_entity.dart';
import '../repos/my_spaces_repo.dart';

class GetMySpacesUseCase {
  final MySpacesRepo repo;
  const GetMySpacesUseCase(this.repo);

  Future<List<SpaceEntity>> call() => repo.getSpaces();
}


