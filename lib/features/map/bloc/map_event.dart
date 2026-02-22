import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object?> get props => [];
}

class MapStarted extends MapEvent {
  const MapStarted();
}

class MapRadiusChanged extends MapEvent {
  final double radiusKm; // 0.5 .. 1.0
  const MapRadiusChanged(this.radiusKm);

  @override
  List<Object?> get props => [radiusKm];
}

class MapMarkerTapped extends MapEvent {
  final String spaceId;
  const MapMarkerTapped(this.spaceId);

  @override
  List<Object?> get props => [spaceId];
}