import '../../domain/entities/best_for_you_space.dart';
import '../../domain/entities/fit_score.dart';
import '../../domain/repos/best_for_you_repo.dart';
import '../sources/best_for_you_remote_source.dart';

class BestForYouRepoDummy implements BestForYouRepo {
  final BestForYouRemoteSource source;
  BestForYouRepoDummy(this.source);

  
  @override
  Future<BestForYouSpace> getBestSpace(String goal) =>
      source.getBestSpace(goal);

  
  @override
  Future<FitScore> getFitScore(String spaceId, String goal) =>
      source.getFitScore(spaceId, goal);

  
  @override
  Future<List<BestForYouSpace>> getTopRatedNearby() =>
      source.getTopRatedNearby();
}
