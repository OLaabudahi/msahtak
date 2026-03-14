import 'package:Msahtak/features/admin/admin_dashboard/data/repos/admin_dashboard_repo_dummy.dart';
import 'package:Msahtak/features/admin/admin_dashboard/domain/entities/admin_dashboard_data_entity.dart';

import '../../domain/entities/admin_dashboard_overview_entity.dart';
import '../../domain/repos/admin_dashboard_repo.dart';
import '../sources/admin_dashboard_source.dart';

class AdminDashboardRepoImpl implements AdminDashboardRepo {
  final AdminDashboardSource source;

  const AdminDashboardRepoImpl({required this.source});

  @override
  Future<AdminDashboardOverviewEntity> getOverview({String? spaceId}) async {
    final model = await source.fetchOverview(spaceId: spaceId);
    return model.toEntity();
  }

  @override
  Future<AdminDashboardDataEntity> getDashboardData() {

    // TODO: implement getDashboardData
    throw UnimplementedError();
  }
}