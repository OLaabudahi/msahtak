import '../../domain/entities/admin_dashboard_overview_entity.dart';
import '../../domain/entities/admin_space_summary_entity.dart';
import '../../domain/entities/admin_dashboard_stats_entity.dart';
import 'admin_space_summary_model.dart';
import 'admin_dashboard_stats_model.dart';

class AdminDashboardOverviewModel {
  final List<AdminSpaceSummaryModel> spaces;
  final String selectedSpaceId;
  final AdminDashboardStatsModel stats;

  const AdminDashboardOverviewModel({
    required this.spaces,
    required this.selectedSpaceId,
    required this.stats,
  });

  factory AdminDashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    final spacesJson = (json['spaces'] as List<dynamic>? ?? const []);
    return AdminDashboardOverviewModel(
      spaces: spacesJson
          .map((e) => AdminSpaceSummaryModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      selectedSpaceId: (json['selectedSpaceId'] ?? '').toString(),
      stats: AdminDashboardStatsModel.fromJson((json['stats'] as Map? ?? const {}).cast<String, dynamic>()),
    );
  }

  Map<String, dynamic> toJson() => {
        'spaces': spaces.map((e) => e.toJson()).toList(),
        'selectedSpaceId': selectedSpaceId,
        'stats': stats.toJson(),
      };

  AdminDashboardOverviewEntity toEntity() {
    final List<AdminSpaceSummaryEntity> spaceEntities = spaces.map((s) => s.toEntity()).toList();
    final AdminSpaceSummaryEntity selected = spaceEntities.firstWhere(
      (s) => s.id == selectedSpaceId,
      orElse: () => spaceEntities.isNotEmpty
          ? spaceEntities.first
          : const AdminSpaceSummaryEntity(id: 'unknown', name: 'Unknown'),
    );

    final AdminDashboardStatsEntity statsEntity = stats.toEntity();

    return AdminDashboardOverviewEntity(
      spaces: spaceEntities,
      selectedSpace: selected,
      stats: statsEntity,
    );
  }
}