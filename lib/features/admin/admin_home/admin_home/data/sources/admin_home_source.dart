import '../models/kpi_model.dart';
import '../../domain/entities/admin_space_item.dart';
import '../../domain/entities/admin_activity_item.dart';

abstract class AdminHomeSource {
  Future<List<AdminSpaceItem>> fetchSpaces();
  Future<List<KpiModel>> fetchKpis({required String spaceId});
  Future<List<AdminActivityItem>> fetchRecentActivity();
}


