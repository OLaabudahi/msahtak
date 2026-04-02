import '../../domain/entities/admin_dashboard_stats_entity.dart';

class AdminDashboardStatsModel {
  final int todaysBookings;
  final int pendingRequests;
  final int occupancyPercent;
  final int weekRevenue;

  const AdminDashboardStatsModel({
    required this.todaysBookings,
    required this.pendingRequests,
    required this.occupancyPercent,
    required this.weekRevenue,
  });

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStatsModel(
      todaysBookings: (json['todaysBookings'] ?? 0) as int,
      pendingRequests: (json['pendingRequests'] ?? 0) as int,
      occupancyPercent: (json['occupancyPercent'] ?? 0) as int,
      weekRevenue: (json['weekRevenue'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'todaysBookings': todaysBookings,
        'pendingRequests': pendingRequests,
        'occupancyPercent': occupancyPercent,
        'weekRevenue': weekRevenue,
      };

  AdminDashboardStatsEntity toEntity() {
    return AdminDashboardStatsEntity(
      todaysBookings: todaysBookings,
      pendingRequests: pendingRequests,
      occupancyPercent: occupancyPercent,
      weekRevenue: weekRevenue,
    );
  }
}

