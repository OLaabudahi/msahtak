import 'package:equatable/equatable.dart';

class GeoPointEntity extends Equatable {
  final double lat;
  final double lng;

  const GeoPointEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}