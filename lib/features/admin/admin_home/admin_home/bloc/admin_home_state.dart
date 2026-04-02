import 'package:equatable/equatable.dart';
import '../domain/entities/kpi_entity.dart';
import '../domain/entities/admin_space_item.dart';
import '../domain/entities/admin_activity_item.dart';

enum AdminHomeStatus { initial, loading, success, failure }

class AdminHomeState extends Equatable {
  final AdminHomeStatus status;
  final List<AdminSpaceItem> spaces;
  final String activeSpaceId;
  final String activeSpaceName;
  final List<KpiEntity> kpis;
  final List<AdminActivityItem> recentActivity;
  final String? error;

  const AdminHomeState({
    required this.status,
    required this.spaces,
    required this.activeSpaceId,
    required this.activeSpaceName,
    required this.kpis,
    required this.recentActivity,
    required this.error,
  });

  factory AdminHomeState.initial() => const AdminHomeState(
        status: AdminHomeStatus.initial,
        spaces: [],
        activeSpaceId: '',
        activeSpaceName: '',
        kpis: [],
        recentActivity: [],
        error: null,
      );

  AdminHomeState copyWith({
    AdminHomeStatus? status,
    List<AdminSpaceItem>? spaces,
    String? activeSpaceId,
    String? activeSpaceName,
    List<KpiEntity>? kpis,
    List<AdminActivityItem>? recentActivity,
    String? error,
  }) {
    return AdminHomeState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
      activeSpaceId: activeSpaceId ?? this.activeSpaceId,
      activeSpaceName: activeSpaceName ?? this.activeSpaceName,
      kpis: kpis ?? this.kpis,
      recentActivity: recentActivity ?? this.recentActivity,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, spaces, activeSpaceId, activeSpaceName, kpis, recentActivity, error];
}


