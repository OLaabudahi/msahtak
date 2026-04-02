import 'package:equatable/equatable.dart';
import 'admin_space_summary_entity.dart';
import 'admin_dashboard_stats_entity.dart';

class AdminDashboardOverviewEntity extends Equatable {
  final List<AdminSpaceSummaryEntity> spaces;
  final AdminSpaceSummaryEntity selectedSpace;
  final AdminDashboardStatsEntity stats;

  const AdminDashboardOverviewEntity({
    required this.spaces,
    required this.selectedSpace,
    required this.stats,
  });

  @override
  List<Object?> get props => [spaces, selectedSpace, stats];
}