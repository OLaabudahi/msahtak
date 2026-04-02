import '../entities/hub.dart';
import '../entities/weekly_plan_details.dart';
import '../repos/weekly_plan_repo.dart';

class GetWeeklyPlanUseCase {
  final WeeklyPlanRepo repo;
  GetWeeklyPlanUseCase(this.repo);

  /// جلب قائمة المساحات وتفاصيل الخطة للمساحة الافتراضية
  Future<({List<Hub> hubs, WeeklyPlanDetails details})> call(
      String hubId) async {
    final hubs = await repo.getHubs();
    final details = await repo.getPlanDetails(hubId);
    return (hubs: hubs, details: details);
  }
}
