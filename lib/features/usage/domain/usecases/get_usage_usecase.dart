import '../entities/plan_option.dart';
import '../entities/usage_stats.dart';
import '../repos/usage_repo.dart';

class GetUsageUseCase {
  final UsageRepo repo;
  GetUsageUseCase(this.repo);

  /// جلب الإحصاءات وخيارات الباقات معاً
  Future<({UsageStats stats, List<PlanOption> plans})> call() async {
    final stats = await repo.getUsageStats();
    final plans = await repo.getPlanOptions();
    return (stats: stats, plans: plans);
  }
}
