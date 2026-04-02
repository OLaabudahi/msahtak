import 'package:equatable/equatable.dart';
import 'geo_point_entity.dart';

class NearbySpaceEntity extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final double rating;
  final String imageUrl;
  final GeoPointEntity location;
  final double distanceKm;

  const NearbySpaceEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.imageUrl,
    required this.location,
    required this.distanceKm,
  });

  @override
  List<Object?> get props => [id, name, subtitle, rating, imageUrl, location, distanceKm];
}
