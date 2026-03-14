import 'package:equatable/equatable.dart';
import '../domain/entities/space_management_entity.dart';

enum SpaceManagementStatus { initial, loading, ready, failure }

class SpaceManagementState extends Equatable {
  final SpaceManagementStatus status;
  final SpaceManagementEntity? space;
  final String? error;

  const SpaceManagementState({
    required this.status,
    required this.space,
    required this.error,
  });

  factory SpaceManagementState.initial() => const SpaceManagementState(status: SpaceManagementStatus.initial, space: null, error: null);

  SpaceManagementState copyWith({SpaceManagementStatus? status, SpaceManagementEntity? space, String? error}) {
    return SpaceManagementState(status: status ?? this.status, space: space ?? this.space, error: error);
  }

  @override
  List<Object?> get props => [status, space, error];
}
