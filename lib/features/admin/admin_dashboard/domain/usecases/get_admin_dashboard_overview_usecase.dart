import 'package:Msahtak/features/admin/admin_dashboard/data/repos/admin_dashboard_repo_impl.dart';

import '../entities/admin_dashboard_overview_entity.dart';
import '../repos/admin_dashboard_repo.dart';

class GetAdminDashboardOverviewUseCase {
  final AdminDashboardRepoImpl repo;

  const GetAdminDashboardOverviewUseCase(this.repo);

  Future<AdminDashboardOverviewEntity> call({String? spaceId}) {
    return repo.getOverview(spaceId: spaceId);
  }
}
