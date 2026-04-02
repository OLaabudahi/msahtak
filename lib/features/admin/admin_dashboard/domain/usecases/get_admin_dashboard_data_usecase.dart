import '../entities/admin_dashboard_data_entity.dart';
import '../repos/admin_dashboard_repo.dart';

class GetAdminDashboardDataUseCase {
  final AdminDashboardRepo repo;

  const GetAdminDashboardDataUseCase(this.repo);

  Future<AdminDashboardDataEntity> call() {
    return repo.getDashboardData();
  }
}


