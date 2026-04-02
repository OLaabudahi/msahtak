import '../../domain/entities/plan_option.dart';
import '../../domain/entities/usage_stats.dart';
import '../../domain/repos/usage_repo.dart';
import '../sources/usage_remote_source.dart';

class UsageRepoDummy implements UsageRepo {
  final UsageRemoteSource source;
  UsageRepoDummy(this.source);

  /// ط¬ظ„ط¨ ط§ظ„ط¥ط­طµط§ط،ط§طھ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<UsageStats> getUsageStats() => source.getUsageStats();

  /// ط¬ظ„ط¨ ط®ظٹط§ط±ط§طھ ط§ظ„ط¨ط§ظ‚ط§طھ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<List<PlanOption>> getPlanOptions() =>
      source.getPlanOptions();

  /// طھط·ط¨ظٹظ‚ ط§ظ„ط¨ط§ظ‚ط© ط¹ط¨ط± ط§ظ„ظ…طµط¯ط±
  @override
  Future<void> applyPlan(String planId) =>
      source.applyPlan(planId);
}


