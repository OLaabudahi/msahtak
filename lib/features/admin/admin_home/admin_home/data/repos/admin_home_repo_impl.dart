import '../../domain/entities/kpi_entity.dart';
import '../../domain/entities/admin_space_item.dart';
import '../../domain/entities/admin_activity_item.dart';
import '../../domain/repos/admin_home_repo.dart';
import '../sources/admin_home_source.dart';

class AdminHomeRepoImpl implements AdminHomeRepo {
  final AdminHomeSource source;
  const AdminHomeRepoImpl(this.source);

  @override
  Future<List<KpiEntity>> getKpis({required String spaceId}) async {
    final list = await source.fetchKpis(spaceId: spaceId);
    return list.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<List<AdminSpaceItem>> getSpaces() => source.fetchSpaces();

  @override
  Future<List<AdminActivityItem>> getRecentActivity() => source.fetchRecentActivity();
}


