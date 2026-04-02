import 'package:equatable/equatable.dart';

class AdminDashboardStats extends Equatable {
  final int todaysBookings;
  final int pendingRequests;
  final int occupancyPercent;
  final int weekRevenue;

  const AdminDashboardStats({
    required this.todaysBookings,
    required this.pendingRequests,
    required this.occupancyPercent,
    required this.weekRevenue,
  });

  @override
  List<Object?> get props => [todaysBookings, pendingRequests, occupancyPercent, weekRevenue];
}

