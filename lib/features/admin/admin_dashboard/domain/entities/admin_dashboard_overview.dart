import 'package:equatable/equatable.dart';
import 'admin_space_summary.dart';
import 'admin_dashboard_stats.dart';

class AdminDashboardOverview extends Equatable {
  final List<AdminSpaceSummary> spaces;
  final AdminSpaceSummary selectedSpace;
  final AdminDashboardStats stats;

  const AdminDashboardOverview({
    required this.spaces,
    required this.selectedSpace,
    required this.stats,
  });

  @override
  List<Object?> get props => [spaces, selectedSpace, stats];
}