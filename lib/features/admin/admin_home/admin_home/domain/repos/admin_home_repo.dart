import '../entities/kpi_entity.dart';
import '../entities/admin_space_item.dart';
import '../entities/admin_activity_item.dart';

abstract class AdminHomeRepo {
  Future<List<KpiEntity>> getKpis({required String spaceId});
  Future<List<AdminSpaceItem>> getSpaces();
  Future<List<AdminActivityItem>> getRecentActivity();
}
