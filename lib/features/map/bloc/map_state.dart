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
  final bool showAll;

  const MapState({
    required this.isLoading,
    required this.error,
    required this.center,
    required this.radiusKm,
    required this.spaces,
    required this.selectedSpaceId,
    this.showAll = false,
  });

  factory MapState.initial() => const MapState(
    isLoading: true,
    error: null,
    center: GeoPointEntity(lat: 31.511136495468655, lng: 34.45187681199389),
    radiusKm: 0.1,
    spaces: [],
    selectedSpaceId: null,
    showAll: false,
  );

  MapState copyWith({
    bool? isLoading,
    String? error,
    GeoPointEntity? center,
    double? radiusKm,
    List<NearbySpaceEntity>? spaces,
    String? selectedSpaceId,
    bool? showAll,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      center: center ?? this.center,
      radiusKm: radiusKm ?? this.radiusKm,
      spaces: spaces ?? this.spaces,
      selectedSpaceId: selectedSpaceId ?? this.selectedSpaceId,
      showAll: showAll ?? this.showAll,
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
  List<Object?> get props => [isLoading, error, center, radiusKm, spaces, selectedSpaceId, showAll];
}