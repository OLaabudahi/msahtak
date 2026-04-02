import 'package:equatable/equatable.dart';

import '../domain/entities/admin_dashboard_data_entity.dart';

enum AdminDashboardStatus { idle, loading, success, error }

class AdminDashboardState extends Equatable {
  final AdminDashboardStatus status;
  final AdminDashboardDataEntity? data;
  final bool dropdownOpen;
  final int navIndex;
  final String? errorMessage;

  const AdminDashboardState({
    required this.status,
    this.data,
    this.dropdownOpen = false,
    this.navIndex = 0,
    this.errorMessage,
  });

  AdminDashboardState copyWith({
    AdminDashboardStatus? status,
    AdminDashboardDataEntity? data,
    bool? dropdownOpen,
    int? navIndex,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      dropdownOpen: dropdownOpen ?? this.dropdownOpen,
      navIndex: navIndex ?? this.navIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, dropdownOpen, navIndex, errorMessage];
}


