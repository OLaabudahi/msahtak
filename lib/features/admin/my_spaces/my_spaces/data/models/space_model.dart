import '../../domain/entities/space_entity.dart';

class SpaceModel {
  final String spaceId;
  final String spaceName;
  final double rating;
  final bool isActive;
  final String imageUrl;

  const SpaceModel({
    required this.spaceId,
    required this.spaceName,
    required this.rating,
    required this.isActive,
    required this.imageUrl,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      spaceId: (json['spaceId'] ?? json['id'] ?? '').toString(),
      spaceName: (json['spaceName'] ?? json['name'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: (json['isActive'] ?? true) as bool,
      imageUrl: (json['imageUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spaceId': spaceId,
      'spaceName': spaceName,
      'rating': rating,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  SpaceEntity toEntity() {
    return SpaceEntity(
      id: spaceId,
      name: spaceName,
      rating: rating.toStringAsFixed(1),
      availability:
      isActive ? SpaceAvailability.available : SpaceAvailability.hidden,
      cover: imageUrl,
    );
  }
}
