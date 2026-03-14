import '../../domain/entities/space_entity.dart';

class SpaceModel {
  final String id;
  final String name;
  final String rating;
  final String availability; // available|hidden
  final String cover;

  const SpaceModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.availability,
    required this.cover,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) => SpaceModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        rating: (json['rating'] ?? '').toString(),
        availability: (json['availability'] ?? 'available').toString(),
        cover: (json['cover'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'rating': rating, 'availability': availability, 'cover': cover};

  SpaceEntity toEntity() {
    final a = availability == 'hidden' ? SpaceAvailability.hidden : SpaceAvailability.available;
    return SpaceEntity(id: id, name: name, rating: rating, availability: a, cover: cover);
  }
}
