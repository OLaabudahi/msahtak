import '../../domain/entities/best_for_you_space.dart';
import '../../domain/entities/fit_score.dart';
import '../../domain/repos/best_for_you_repo.dart';
import '../sources/best_for_you_remote_source.dart';

class BestForYouRepoDummy implements BestForYouRepo {
  final BestForYouRemoteSource source;
  BestForYouRepoDummy(this.source);

  /// ط¬ظ„ط¨ ط§ظ„ظ…ط³ط§ط­ط© ط§ظ„ط£ظپط¶ظ„ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<BestForYouSpace> getBestSpace(String goal) =>
      source.getBestSpace(goal);

  /// ط¬ظ„ط¨ ط¯ط±ط¬ط© ط§ظ„طھط·ط§ط¨ظ‚ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<FitScore> getFitScore(String spaceId, String goal) =>
      source.getFitScore(spaceId, goal);

  /// ط¬ظ„ط¨ ط£ط¹ظ„ظ‰ 5 ظ…ط³ط§ط­ط§طھ ظ‚ط±ظٹط¨ط© ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<List<BestForYouSpace>> getTopRatedNearby() =>
      source.getTopRatedNearby();
}


