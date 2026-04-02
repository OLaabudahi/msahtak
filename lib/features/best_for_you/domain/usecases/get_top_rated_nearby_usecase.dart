import '../entities/best_for_you_space.dart';
import '../repos/best_for_you_repo.dart';

class GetTopRatedNearbyUseCase {
  final BestForYouRepo repo;
  GetTopRatedNearbyUseCase(this.repo);

  Future<List<BestForYouSpace>> call() => repo.getTopRatedNearby();
}
