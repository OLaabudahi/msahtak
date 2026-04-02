import '../repos/usage_repo.dart';

class ApplyPlanUseCase {
  final UsageRepo repo;
  ApplyPlanUseCase(this.repo);

  /// طھط·ط¨ظٹظ‚ ط§ظ„ط¨ط§ظ‚ط© ط§ظ„ظ…ط®طھط§ط±ط©
  Future<void> call(String planId) => repo.applyPlan(planId);
}


