import '../../domain/entities/geo_point_entity.dart';
import '../../domain/entities/nearby_space_entity.dart';

class NearbySpaceModel {
  final String id;
  final String name;
  final String subtitle;
  final double rating;
  final String imageUrl;
  final double lat;
  final double lng;
  final double distanceKm;

  const NearbySpaceModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    required this.distanceKm,
  });

  factory NearbySpaceModel.fromJson(Map<String, dynamic> json) {
    return NearbySpaceModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subtitle': subtitle,
    'rating': rating,
    'imageUrl': imageUrl,
    'lat': lat,
    'lng': lng,
    'distanceKm': distanceKm,
  };

  NearbySpaceEntity toEntity() => NearbySpaceEntity(
    id: id,
    name: name,
    subtitle: subtitle,
    rating: rating,
    imageUrl: imageUrl,
    location: GeoPointEntity(lat: lat, lng: lng),
    distanceKm: distanceKm,
  );
}

