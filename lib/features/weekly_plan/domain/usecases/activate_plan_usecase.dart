import '../repos/weekly_plan_repo.dart';

class ActivatePlanUseCase {
  final WeeklyPlanRepo repo;
  ActivatePlanUseCase(this.repo);

  
  Future<void> call(String hubId) => repo.activatePlan(hubId);
}
