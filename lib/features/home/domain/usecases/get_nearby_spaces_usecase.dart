import '../entities/home_featured_space_entity.dart';
import '../repos/home_repo.dart';

class GetNearbySpacesUseCase {
  final HomeRepo repo;

  const GetNearbySpacesUseCase(this.repo);

  Future<List<HomeFeaturedSpaceEntity>> call() {
    return repo.getNearbySpaces();
  }
}
