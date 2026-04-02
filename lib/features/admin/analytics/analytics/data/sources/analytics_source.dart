import '../models/analytics_model.dart';

abstract class AnalyticsSource {
  Future<AnalyticsModel> fetchAnalytics();
  Future<void> exportReport();
}


