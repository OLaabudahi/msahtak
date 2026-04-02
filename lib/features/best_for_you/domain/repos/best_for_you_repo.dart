import '../entities/best_for_you_space.dart';
import '../entities/fit_score.dart';

abstract class BestForYouRepo {
  
  Future<BestForYouSpace> getBestSpace(String goal);

  
  Future<FitScore> getFitScore(String spaceId, String goal);

  
  Future<List<BestForYouSpace>> getTopRatedNearby();
}
