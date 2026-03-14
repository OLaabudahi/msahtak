import 'package:equatable/equatable.dart';
import '../domain/entities/space_entity.dart';

enum MySpacesStatus { initial, loading, success, failure }

class MySpacesState extends Equatable {
  final MySpacesStatus status;
  final List<SpaceEntity> spaces;
  final String? error;

  const MySpacesState({
    required this.status,
    required this.spaces,
    required this.error,
  });

  factory MySpacesState.initial() => const MySpacesState(status: MySpacesStatus.initial, spaces: [], error: null);

  MySpacesState copyWith({MySpacesStatus? status, List<SpaceEntity>? spaces, String? error}) {
    return MySpacesState(status: status ?? this.status, spaces: spaces ?? this.spaces, error: error);
  }

  @override
  List<Object?> get props => [status, spaces, error];
}
