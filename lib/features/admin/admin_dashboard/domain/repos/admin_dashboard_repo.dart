import '../entities/admin_dashboard_data_entity.dart';

abstract class AdminDashboardRepo {
  Future<AdminDashboardDataEntity> getDashboardData();
  // API-ready: Future<AdminDashboardDataEntity> getDashboardData({required String spaceId});
}


