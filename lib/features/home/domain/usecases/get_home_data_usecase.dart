import '../entities/home_featured_space_entity.dart';
import '../repos/home_repo.dart';

class GetHomeDataUseCase {
  final HomeRepo repo;

  const GetHomeDataUseCase(this.repo);

  Future<List<HomeFeaturedSpaceEntity>> call() {
    return repo.getHomeData();
  }
}
