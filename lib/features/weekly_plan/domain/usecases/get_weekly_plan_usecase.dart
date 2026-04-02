import '../entities/hub.dart';
import '../entities/weekly_plan_details.dart';
import '../repos/weekly_plan_repo.dart';

class GetWeeklyPlanUseCase {
  final WeeklyPlanRepo repo;
  GetWeeklyPlanUseCase(this.repo);

  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„ظ…ط³ط§ط­ط§طھ ظˆطھظپط§طµظٹظ„ ط§ظ„ط®ط·ط© ظ„ظ„ظ…ط³ط§ط­ط© ط§ظ„ط§ظپطھط±ط§ط¶ظٹط©
  Future<({List<Hub> hubs, WeeklyPlanDetails details})> call(
      String hubId) async {
    final hubs = await repo.getHubs();
    final details = await repo.getPlanDetails(hubId);
    return (hubs: hubs, details: details);
  }
}


