import '../../domain/entities/space_entity.dart';

class SpaceModel {
  final String id;
  final String name;
  final String locationName;
  final double distanceKm;
  final double pricePerDay;
  final double rating;
  final List<String> tags;

  const SpaceModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.distanceKm,
    required this.pricePerDay,
    required this.rating,
    required this.tags,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      locationName: (json['locationName'] ?? '').toString(),
      distanceKm: (json['distanceKm'] is num) ? (json['distanceKm'] as num).toDouble() : 0,
      pricePerDay: (json['pricePerDay'] is num) ? (json['pricePerDay'] as num).toDouble() : 0,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0,
      tags: (json['tags'] is List) ? (json['tags'] as List).map((e) => e.toString()).toList() : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'locationName': locationName,
    'distanceKm': distanceKm,
    'pricePerDay': pricePerDay,
    'rating': rating,
    'tags': tags,
  };

  SpaceEntity toEntity() {
    return SpaceEntity(
      id: id,
      name: name,
      locationName: locationName,
      distanceKm: distanceKm,
      pricePerDay: pricePerDay,
      rating: rating,
      tags: tags,
    );
  }
}
