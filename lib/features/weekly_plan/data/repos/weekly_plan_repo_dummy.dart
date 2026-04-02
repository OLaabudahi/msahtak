import '../../domain/entities/hub.dart';
import '../../domain/entities/weekly_plan_details.dart';
import '../../domain/repos/weekly_plan_repo.dart';
import '../sources/weekly_plan_remote_source.dart';

class WeeklyPlanRepoDummy implements WeeklyPlanRepo {
  final WeeklyPlanRemoteSource source;
  WeeklyPlanRepoDummy(this.source);

  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„ظ…ط³ط§ط­ط§طھ ظˆطھط­ظˆظٹظ„ظ‡ط§ ط¥ظ„ظ‰ entities
  @override
  Future<List<Hub>> getHubs() => source.getHubs();

  /// ط¬ظ„ط¨ طھظپط§طµظٹظ„ ط§ظ„ط®ط·ط© ظˆطھط­ظˆظٹظ„ظ‡ط§ ط¥ظ„ظ‰ entity
  @override
  Future<WeeklyPlanDetails> getPlanDetails(String hubId) =>
      source.getPlanDetails(hubId);

  /// طھظپط¹ظٹظ„ ط§ظ„ط®ط·ط© ط¹ط¨ط± ط§ظ„ظ…طµط¯ط±
  @override
  Future<void> activatePlan(String hubId) =>
      source.activatePlan(hubId);
}


