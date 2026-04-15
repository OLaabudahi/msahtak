import 'package:equatable/equatable.dart';

import '../../search_results/domain/entities/space_entity.dart';

class SavedSpacesState extends Equatable {
  final bool loading;
  final String? error;
  final List<SpaceEntity> spaces;

  const SavedSpacesState({
    required this.loading,
    required this.error,
    required this.spaces,
  });

  factory SavedSpacesState.initial() => const SavedSpacesState(
        loading: true,
        error: null,
        spaces: [],
      );

  SavedSpacesState copyWith({
    bool? loading,
    String? error,
    List<SpaceEntity>? spaces,
  }) {
    return SavedSpacesState(
      loading: loading ?? this.loading,
      error: error,
      spaces: spaces ?? this.spaces,
    );
  }

  @override
  List<Object?> get props => [loading, error, spaces];
}
