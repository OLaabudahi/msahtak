import 'package:equatable/equatable.dart';
import '../domain/entities/geo_point_entity.dart';
import '../domain/entities/nearby_space_entity.dart';

class MapState extends Equatable {
  final bool isLoading;
  final String? error;
  final GeoPointEntity? center;
  final double radiusKm;
  final List<NearbySpaceEntity> spaces;
  final String? selectedSpaceId;

  const MapState({
    required this.isLoading,
    required this.error,
    required this.center,
    required this.radiusKm,
    required this.spaces,
    required this.selectedSpaceId,
  });

  factory MapState.initial() => const MapState(
    isLoading: true,
    error: null,
    center: null,
    radiusKm: 1.0,
    spaces: [],
    selectedSpaceId: null,
  );

  MapState copyWith({
    bool? isLoading,
    String? error,
    GeoPointEntity? center,
    double? radiusKm,
    List<NearbySpaceEntity>? spaces,
    String? selectedSpaceId,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      center: center ?? this.center,
      radiusKm: radiusKm ?? this.radiusKm,
      spaces: spaces ?? this.spaces,
      selectedSpaceId: selectedSpaceId ?? this.selectedSpaceId,
    );
  }

  NearbySpaceEntity? get selectedSpace {
    if (spaces.isEmpty) return null;
    if (selectedSpaceId == null) return spaces.first;
    return spaces.firstWhere(
          (s) => s.id == selectedSpaceId,
      orElse: () => spaces.first,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, center, radiusKm, spaces, selectedSpaceId];
}