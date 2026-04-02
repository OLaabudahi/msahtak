import '../entities/plan_option.dart';
import '../entities/usage_stats.dart';

abstract class UsageRepo {
  /// ط¬ظ„ط¨ ط¥ط­طµط§ط،ط§طھ ط§ظ„ط§ط³طھط®ط¯ط§ظ…
  Future<UsageStats> getUsageStats();

  /// ط¬ظ„ط¨ ط®ظٹط§ط±ط§طھ ط§ظ„ط¨ط§ظ‚ط§طھ ط§ظ„ظ…طھط§ط­ط©
  Future<List<PlanOption>> getPlanOptions();

  /// طھط·ط¨ظٹظ‚ ط§ظ„ط¨ط§ظ‚ط© ط§ظ„ظ…ط®طھط§ط±ط©
  Future<void> applyPlan(String planId);
}


