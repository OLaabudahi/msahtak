import '../entities/analytics_entity.dart';

abstract class AnalyticsRepo {
  Future<AnalyticsEntity> getAnalytics();
  Future<void> exportReport();
}
