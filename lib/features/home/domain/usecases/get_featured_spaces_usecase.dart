import '../entities/home_featured_space_entity.dart';
import '../repos/home_repo.dart';

class GetFeaturedSpacesUseCase {
  final HomeRepo repo;

  const GetFeaturedSpacesUseCase(this.repo);

  Future<List<HomeFeaturedSpaceEntity>> call() {
    return repo.getFeaturedSpaces();
  }
}
