import '../models/admin_dashboard_overview_model.dart';

abstract class AdminDashboardSource {
  /// API-ready:
  /// Implement using Dio/http later, keep this file as the single gateway.
  Future<AdminDashboardOverviewModel> fetchOverview({String? spaceId});
}

