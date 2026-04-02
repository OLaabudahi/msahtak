import '../entities/best_for_you_space.dart';
import '../entities/fit_score.dart';

abstract class BestForYouRepo {
  /// ط¬ظ„ط¨ ط£ظپط¶ظ„ ظ…ط³ط§ط­ط© ظ„ظ„ظ…ط³طھط®ط¯ظ… ط¨ظ†ط§ط،ظ‹ ط¹ظ„ظ‰ ط§ظ„ظ‡ط¯ظپ
  Future<BestForYouSpace> getBestSpace(String goal);

  /// ط¬ظ„ط¨ ط¯ط±ط¬ط© ط§ظ„طھط·ط§ط¨ظ‚ ظ„ظ„ظ…ط³ط§ط­ط© ظ…ط¹ ط§ظ„ظ‡ط¯ظپ ط§ظ„ظ…ط­ط¯ط¯
  Future<FitScore> getFitScore(String spaceId, String goal);

  /// ط¬ظ„ط¨ ط£ط¹ظ„ظ‰ 5 ظ…ط³ط§ط­ط§طھ طھظ‚ظٹظٹظ…ط§ظ‹ ط¶ظ…ظ† 100 ظ…طھط±
  Future<List<BestForYouSpace>> getTopRatedNearby();
}


