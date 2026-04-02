import '../entities/plan_option.dart';
import '../entities/usage_stats.dart';

abstract class UsageRepo {
  
  Future<UsageStats> getUsageStats();

  
  Future<List<PlanOption>> getPlanOptions();

  
  Future<void> applyPlan(String planId);
}
