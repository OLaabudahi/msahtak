import '../entities/hub.dart';
import '../entities/weekly_plan_details.dart';

abstract class WeeklyPlanRepo {
  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„ظ…ط³ط§ط­ط§طھ ط§ظ„ظ…طھط§ط­ط©
  Future<List<Hub>> getHubs();

  /// ط¬ظ„ط¨ طھظپط§طµظٹظ„ ط§ظ„ط®ط·ط© ط§ظ„ط£ط³ط¨ظˆط¹ظٹط© ظ„ظ…ط³ط§ط­ط© ظ…ط¹ظٹظ†ط©
  Future<WeeklyPlanDetails> getPlanDetails(String hubId);

  /// طھظپط¹ظٹظ„ ط§ظ„ط®ط·ط© ط§ظ„ط£ط³ط¨ظˆط¹ظٹط©
  Future<void> activatePlan(String hubId);
}


