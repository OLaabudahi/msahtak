import 'admin_home_source.dart';
import '../models/kpi_model.dart';
import '../../domain/entities/admin_space_item.dart';
import '../../domain/entities/admin_activity_item.dart';
import '../../domain/entities/admin_notification_item.dart';

class AdminHomeDummySource implements AdminHomeSource {
  @override
  Future<List<AdminSpaceItem>> fetchSpaces() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return const [
      AdminSpaceItem(id: 'space1', name: 'Downtown Hub'),
      AdminSpaceItem(id: 'space2', name: 'Creative Studio'),
      AdminSpaceItem(id: 'space3', name: 'Tech Center'),
    ];
  }

  @override
  Future<List<AdminActivityItem>> fetchRecentActivity() async {
    return [];
  }

  @override
  Future<List<KpiModel>> fetchKpis({required String spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return const [
      KpiModel(id: 'today', title: 'Today Bookings', value: '12', delta: '+2 vs yesterday'),
      KpiModel(id: 'pending', title: 'Pending Requests', value: '5', delta: 'Needs review'),
      KpiModel(id: 'occupancy', title: 'Occupancy Now', value: '78%', delta: '+6%'),
      KpiModel(id: 'revenue', title: 'Weekly Revenue', value: '\$1,240', delta: '+12%'),
    ];
  }

  @override
  Future<List<AdminNotificationItem>> fetchNotifications() async {
    return const [];
  }
}


