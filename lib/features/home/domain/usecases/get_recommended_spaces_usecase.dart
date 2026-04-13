import '../entities/home_featured_space_entity.dart';
import '../repos/home_repo.dart';

class GetRecommendedSpacesUseCase {
  final HomeRepo repo;

  const GetRecommendedSpacesUseCase(this.repo);

  Future<List<HomeFeaturedSpaceEntity>> call() {
    return repo.getRecommendedSpaces();
  }
}
