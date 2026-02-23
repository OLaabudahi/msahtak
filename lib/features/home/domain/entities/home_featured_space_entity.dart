import 'package:equatable/equatable.dart';

class HomeFeaturedSpaceEntity extends Equatable {
  final String id;
  final String name;
  final String imageAsset;
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

  const HomeFeaturedSpaceEntity({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.subtitleLine,
    required this.rating,
    required this.pricePerDay,
    required this.currency,
    this.lat,
    this.lng,
    this.distanceKm,
  });

  String get ratingText => rating.toStringAsFixed(1);

  @override
  List<Object?> get props => [
    id,
    name,
    imageAsset,
    subtitleLine,
    rating,
    pricePerDay,
    currency,
    lat,
    lng,
    distanceKm,
  ];
}