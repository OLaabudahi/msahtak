import 'package:equatable/equatable.dart';

enum AdminStatIcon { bookings, pending, occupancy, revenue }

class AdminDashboardStatEntity extends Equatable {
  final String label;
  final String value;
  final AdminStatIcon icon;
  final int colorHex;

  const AdminDashboardStatEntity({
    required this.label,
    required this.value,
    required this.icon,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [label, value, icon, colorHex];
}

class AdminDashboardActivityEntity extends Equatable {
  final String user;
  final String action;
  final String space;
  final String time;

  const AdminDashboardActivityEntity({
    required this.user,
    required this.action,
    required this.space,
    required this.time,
  });

  @override
  List<Object?> get props => [user, action, space, time];
}

class AdminDashboardDataEntity extends Equatable {
  final List<String> spaces;
  final String selectedSpace;
  final List<AdminDashboardStatEntity> stats;
  final List<AdminDashboardActivityEntity> activities;

  const AdminDashboardDataEntity({
    required this.spaces,
    required this.selectedSpace,
    required this.stats,
    required this.activities,
  });

  AdminDashboardDataEntity copyWith({
    List<String>? spaces,
    String? selectedSpace,
    List<AdminDashboardStatEntity>? stats,
    List<AdminDashboardActivityEntity>? activities,
  }) {
    return AdminDashboardDataEntity(
      spaces: spaces ?? this.spaces,
      selectedSpace: selectedSpace ?? this.selectedSpace,
      stats: stats ?? this.stats,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [spaces, selectedSpace, stats, activities];
}