import '../models/admin_dashboard_overview_model.dart';

abstract class AdminDashboardSource {

  Future<AdminDashboardOverviewModel> fetchOverview({String? spaceId});
}
