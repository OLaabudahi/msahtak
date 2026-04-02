import '../../domain/entities/plan_option.dart';
import '../../domain/entities/usage_stats.dart';
import '../../domain/repos/usage_repo.dart';
import '../sources/usage_remote_source.dart';

class UsageRepoDummy implements UsageRepo {
  final UsageRemoteSource source;
  UsageRepoDummy(this.source);

  
  @override
  Future<UsageStats> getUsageStats() => source.getUsageStats();

  
  @override
  Future<List<PlanOption>> getPlanOptions() =>
      source.getPlanOptions();

  
  @override
  Future<void> applyPlan(String planId) =>
      source.applyPlan(planId);
}
