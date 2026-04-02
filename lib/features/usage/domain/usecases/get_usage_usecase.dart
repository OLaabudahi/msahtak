import '../entities/plan_option.dart';
import '../entities/usage_stats.dart';
import '../repos/usage_repo.dart';

class GetUsageUseCase {
  final UsageRepo repo;
  GetUsageUseCase(this.repo);

  /// ط¬ظ„ط¨ ط§ظ„ط¥ط­طµط§ط،ط§طھ ظˆط®ظٹط§ط±ط§طھ ط§ظ„ط¨ط§ظ‚ط§طھ ظ…ط¹ط§ظ‹
  Future<({UsageStats stats, List<PlanOption> plans})> call() async {
    final stats = await repo.getUsageStats();
    final plans = await repo.getPlanOptions();
    return (stats: stats, plans: plans);
  }
}


