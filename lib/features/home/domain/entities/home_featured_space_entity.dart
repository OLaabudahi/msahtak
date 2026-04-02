import 'package:equatable/equatable.dart';

class HomeFeaturedSpaceEntity extends Equatable {
  final String id;
  final String name;
  final String imageAsset;
  final String? imageUrl;
  final String subtitleLine;
  final double rating;

  /// ✅ للانتقال والـ booking لاحقًا
  final int pricePerDay;
  final String currency;

  /// ✅ جديد: لدعم الخريطة والـ Nearly (اختياري)
  final double? lat;
  final double? lng;

  /// ✅ جديد: مسافة تقريبية (اختياري) – API-ready
  final double? distanceKm;

  /// ✅ تاغات المساحة (wifi, parking, quiet, …)
  final List<String> tags;

  const HomeFeaturedSpaceEntity({
    required this.id,
    required this.name,
    required this.imageAsset,
    this.imageUrl,
    required this.subtitleLine,
    required this.rating,
    required this.pricePerDay,
    required this.currency,
    this.lat,
    this.lng,
    this.distanceKm,
    this.tags = const [],
  });

  String get ratingText => rating.toStringAsFixed(1);

  @override
  List<Object?> get props => [
    id,
    name,
    imageAsset,
    imageUrl,
    subtitleLine,
    rating,
    pricePerDay,
    currency,
    lat,
    lng,
    distanceKm,
    tags,
  ];
}
