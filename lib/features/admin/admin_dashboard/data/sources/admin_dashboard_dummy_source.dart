import 'admin_dashboard_source.dart';
import '../models/admin_dashboard_overview_model.dart';
import '../models/admin_space_summary_model.dart';
import '../models/admin_dashboard_stats_model.dart';

class AdminDashboardDummySource implements AdminDashboardSource {
  @override
  Future<AdminDashboardOverviewModel> fetchOverview({String? spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final spaces = <AdminSpaceSummaryModel>[
      const AdminSpaceSummaryModel(id: 'downtown', name: 'Downtown Hub'),
      const AdminSpaceSummaryModel(id: 'creative', name: 'Creative Studio'),
      const AdminSpaceSummaryModel(id: 'tech', name: 'Tech Center'),
      const AdminSpaceSummaryModel(id: 'city', name: 'City Office'),
    ];

    final selectedId = (spaceId != null && spaces.any((s) => s.id == spaceId))
        ? spaceId
        : spaces.first.id;

    final stats = const AdminDashboardStatsModel(
      todaysBookings: 12,
      pendingRequests: 3,
      occupancyPercent: 68,
      weekRevenue: 1420,
    );

    return AdminDashboardOverviewModel(
      spaces: spaces,
      selectedSpaceId: selectedId,
      stats: stats,
    );
  }
}
