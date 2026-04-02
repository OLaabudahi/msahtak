import '../repos/weekly_plan_repo.dart';

class ActivatePlanUseCase {
  final WeeklyPlanRepo repo;
  ActivatePlanUseCase(this.repo);

  /// طھظپط¹ظٹظ„ ط§ظ„ط®ط·ط© ط§ظ„ط£ط³ط¨ظˆط¹ظٹط© ظ„ظ„ظ…ط³ط§ط­ط© ط§ظ„ظ…ط­ط¯ط¯ط©
  Future<void> call(String hubId) => repo.activatePlan(hubId);
}


