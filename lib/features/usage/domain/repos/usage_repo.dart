import '../entities/plan_option.dart';
import '../entities/usage_stats.dart';

abstract class UsageRepo {
  /// جلب إحصاءات الاستخدام
  Future<UsageStats> getUsageStats();

  /// جلب خيارات الباقات المتاحة
  Future<List<PlanOption>> getPlanOptions();

  /// تطبيق الباقة المختارة
  Future<void> applyPlan(String planId);
}
