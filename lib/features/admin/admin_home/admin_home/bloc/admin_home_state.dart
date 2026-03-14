import 'package:equatable/equatable.dart';
import '../domain/entities/kpi_entity.dart';

enum AdminHomeStatus { initial, loading, success, failure }

class AdminHomeState extends Equatable {
  final AdminHomeStatus status;
  final List<String> spaces;
  final String activeSpace;
  final List<KpiEntity> kpis;
  final String? error;

  const AdminHomeState({
    required this.status,
    required this.spaces,
    required this.activeSpace,
    required this.kpis,
    required this.error,
  });

  factory AdminHomeState.initial() => const AdminHomeState(
        status: AdminHomeStatus.initial,
        spaces: [],
        activeSpace: '',
        kpis: [],
        error: null,
      );

  AdminHomeState copyWith({
    AdminHomeStatus? status,
    List<String>? spaces,
    String? activeSpace,
    List<KpiEntity>? kpis,
    String? error,
  }) {
    return AdminHomeState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
      activeSpace: activeSpace ?? this.activeSpace,
      kpis: kpis ?? this.kpis,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, spaces, activeSpace, kpis, error];
}
