import '../../domain/entities/plan_option.dart';
import '../../domain/entities/usage_stats.dart';
import '../../domain/repos/usage_repo.dart';
import '../sources/usage_remote_source.dart';

class UsageRepoDummy implements UsageRepo {
  final UsageRemoteSource source;
  UsageRepoDummy(this.source);

  /// جلب الإحصاءات من المصدر
  @override
  Future<UsageStats> getUsageStats() => source.getUsageStats();

  /// جلب خيارات الباقات من المصدر
  @override
  Future<List<PlanOption>> getPlanOptions() =>
      source.getPlanOptions();

  /// تطبيق الباقة عبر المصدر
  @override
  Future<void> applyPlan(String planId) =>
      source.applyPlan(planId);
}
