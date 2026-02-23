import '../repos/usage_repo.dart';

class ApplyPlanUseCase {
  final UsageRepo repo;
  ApplyPlanUseCase(this.repo);

  /// تطبيق الباقة المختارة
  Future<void> call(String planId) => repo.applyPlan(planId);
}
