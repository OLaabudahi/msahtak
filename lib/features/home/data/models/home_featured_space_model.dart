import '../../domain/entities/home_featured_space_entity.dart';

class HomeFeaturedSpaceModel {
  final String id;
  final String name;
  final String imageAsset;
  final String subtitleLine;
  final double rating;
  final int pricePerDay;
  final String currency;

  final double lat;
  final double lng;
  final double distanceKm;

  const HomeFeaturedSpaceModel({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.subtitleLine,
    required this.rating,
    required this.pricePerDay,
    required this.currency,
    required this.lat,
    required this.lng,
    required this.distanceKm,
  });

  /// ✅ API-ready (معلّق)
  // factory HomeFeaturedSpaceModel.fromJson(Map<String, dynamic> json) { ... }

  HomeFeaturedSpaceEntity toEntity() => HomeFeaturedSpaceEntity(
    id: id,
    name: name,
    imageAsset: imageAsset,
    subtitleLine: subtitleLine,
    rating: rating,
    pricePerDay: pricePerDay,
    currency: currency,
    lat: lat,
    lng: lng,
    distanceKm: distanceKm,
  );
}