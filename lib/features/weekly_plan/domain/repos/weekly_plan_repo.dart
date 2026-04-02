import '../entities/hub.dart';
import '../entities/weekly_plan_details.dart';

abstract class WeeklyPlanRepo {
  /// جلب قائمة المساحات المتاحة
  Future<List<Hub>> getHubs();

  /// جلب تفاصيل الخطة الأسبوعية لمساحة معينة
  Future<WeeklyPlanDetails> getPlanDetails(String hubId);

  /// تفعيل الخطة الأسبوعية
  Future<void> activatePlan(String hubId);
}
