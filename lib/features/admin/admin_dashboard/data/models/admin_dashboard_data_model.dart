import '../../domain/entities/admin_dashboard_data_entity.dart';

class AdminDashboardStatModel {
  final String label;
  final String value;
  final AdminStatIcon icon;
  final int colorHex;

  const AdminDashboardStatModel({
    required this.label,
    required this.value,
    required this.icon,
    required this.colorHex,
  });

  AdminDashboardStatEntity toEntity() {
    return AdminDashboardStatEntity(
      label: label,
      value: value,
      icon: icon,
      colorHex: colorHex,
    );
  }
}

class AdminDashboardActivityModel {
  final String user;
  final String action;
  final String space;
  final String time;

  const AdminDashboardActivityModel({
    required this.user,
    required this.action,
    required this.space,
    required this.time,
  });

  AdminDashboardActivityEntity toEntity() {
    return AdminDashboardActivityEntity(
      user: user,
      action: action,
      space: space,
      time: time,
    );
  }
}

class AdminDashboardDataModel {
  final List<String> spaces;
  final String selectedSpace;
  final List<AdminDashboardStatModel> stats;
  final List<AdminDashboardActivityModel> activities;

  const AdminDashboardDataModel({
    required this.spaces,
    required this.selectedSpace,
    required this.stats,
    required this.activities,
  });

  AdminDashboardDataEntity toEntity() {
    return AdminDashboardDataEntity(
      spaces: spaces,
      selectedSpace: selectedSpace,
      stats: stats.map((e) => e.toEntity()).toList(),
      activities: activities.map((e) => e.toEntity()).toList(),
    );
  }
}

