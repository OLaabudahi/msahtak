import '../../domain/entities/admin_dashboard_data_entity.dart';
import '../../domain/repos/admin_dashboard_repo.dart';
import '../models/admin_dashboard_data_model.dart';

class AdminDashboardRepoDummy implements AdminDashboardRepo {
  @override
  Future<AdminDashboardDataEntity> getDashboardData() async {
    const spaces = ['Downtown Hub', 'Creative Studio', 'Tech Center', 'City Office'];

    const stats = [
      AdminDashboardStatModel(
        label: "Today's Bookings",
        value: '12',
        icon: AdminStatIcon.bookings,
        colorHex: 0xFF5682AF,
      ),
      AdminDashboardStatModel(
        label: 'Pending Requests',
        value: '5',
        icon: AdminStatIcon.pending,
        colorHex: 0xFFFBAD20,
      ),
      AdminDashboardStatModel(
        label: 'Current Occupancy',
        value: '78%',
        icon: AdminStatIcon.occupancy,
        colorHex: 0xFF5682AF,
      ),
      AdminDashboardStatModel(
        label: 'Week Revenue',
        value: '\$8,450',
        icon: AdminStatIcon.revenue,
        colorHex: 0xFF20FB36,
      ),
    ];

    const activities = [
      AdminDashboardActivityModel(user: 'Sarah Johnson', action: 'booked', space: 'Room A', time: '10 min ago'),
      AdminDashboardActivityModel(user: 'Mike Chen', action: 'checked in', space: 'Hot Desk 3', time: '25 min ago'),
      AdminDashboardActivityModel(user: 'Emily Brown', action: 'requested', space: 'Meeting Room B', time: '1 hour ago'),
    ];

    const model = AdminDashboardDataModel(
      spaces: spaces,
      selectedSpace: 'Downtown Hub',
      stats: stats,
      activities: activities,
    );

    return model.toEntity();
  }
}
