import '../../domain/entities/hub.dart';
import '../../domain/entities/weekly_plan_details.dart';
import '../../domain/repos/weekly_plan_repo.dart';
import '../sources/weekly_plan_remote_source.dart';

class WeeklyPlanRepoDummy implements WeeklyPlanRepo {
  final WeeklyPlanRemoteSource source;
  WeeklyPlanRepoDummy(this.source);

  /// جلب قائمة المساحات وتحويلها إلى entities
  @override
  Future<List<Hub>> getHubs() => source.getHubs();

  /// جلب تفاصيل الخطة وتحويلها إلى entity
  @override
  Future<WeeklyPlanDetails> getPlanDetails(String hubId) =>
      source.getPlanDetails(hubId);

  /// تفعيل الخطة عبر المصدر
  @override
  Future<void> activatePlan(String hubId) =>
      source.activatePlan(hubId);
}
