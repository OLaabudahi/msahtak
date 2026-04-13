import 'dart:math';

import '../../../../constants/app_assets.dart';
import '../../../../services/location_service.dart';
import '../../domain/entities/home_featured_space_entity.dart';
import '../../domain/repos/home_repo.dart';
import '../sources/home_firebase_source.dart';

class HomeRepoFirebase implements HomeRepo {
  final HomeSource source;

  HomeRepoFirebase(this.source);

  static const double _fallbackLat = 31.511136495468655;
  static const double _fallbackLng = 34.45187681199389;

  @override
  Future<List<HomeFeaturedSpaceEntity>> getHomeData() {
    return _fetchAllSpaces();
  }

  @override
  Future<List<HomeFeaturedSpaceEntity>> getRecommendedSpaces() async {
    final all = await _fetchAllSpaces();
    return all.take(10).toList(growable: false);
  }

  @override
  Future<List<HomeFeaturedSpaceEntity>> getNearbySpaces() async {
    final all = await _fetchAllSpaces();
    return all.where((s) => (s.distanceKm ?? 999) <= 5).toList(growable: false);
  }

  @override
  Future<List<HomeFeaturedSpaceEntity>> getFeaturedSpaces() async {
    final all = await _fetchAllSpaces();
    return all.where((s) => s.rating >= 4).toList(growable: false);
  }

  Future<List<HomeFeaturedSpaceEntity>> _fetchAllSpaces() async {
    final pos = await LocationService.getCurrentPosition();
    final double myLat = pos?.latitude ?? _fallbackLat;
    final double myLng = pos?.longitude ?? _fallbackLng;

    final snap = await source.fetchSpaces();

    final result = snap.map((d) {
      final name = d['name'] as String? ?? d['spaceName'] as String? ?? 'Space';

      final subtitle = d['subtitle'] as String? ??
          d['subtitleLine'] as String? ??
          d['description'] as String? ??
          '';

      final loc = d['location'];
      double? lat;
      double? lng;

      if (loc is Map) {
        lat = (loc['lat'] as num?)?.toDouble() ?? (loc['latitude'] as num?)?.toDouble();
        lng = (loc['lng'] as num?)?.toDouble() ?? (loc['longitude'] as num?)?.toDouble();
      }

      final double? dist =
          (lat != null && lng != null) ? _distanceKm(myLat, myLng, lat, lng) : null;

      final pricing = d['pricing'] as Map<String, dynamic>?;
      final pricePerDay = (d['basePriceValue'] as num?)?.toInt() ??
          (d['price_per_day'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          (pricing?['pricePerDay'] as num?)?.toInt() ??
          (pricing?['price_per_day'] as num?)?.toInt() ??
          (d['pricePerHour'] as num?)?.toInt() ??
          0;

      final stats = d['stats'] as Map<String, dynamic>?;
      final rating = (d['rating'] as num?)?.toDouble() ??
          (stats?['averageRating'] as num?)?.toDouble() ??
          4.0;

      final rawTags = d['tags'];
      final tags = <String>[];
      if (rawTags is List) {
        for (final t in rawTags) {
          if (t is String) tags.add(t.toLowerCase());
        }
      }

      final imagesList = (d['images'] as List?)?.cast<String>() ?? const [];
      final firstImageUrl = imagesList.isNotEmpty
          ? imagesList.first
          : (d['imageUrl'] as String? ?? d['cover'] as String? ?? d['thumbnailUrl'] as String?);

      return HomeFeaturedSpaceEntity(
        id: d['id'] as String,
        name: name,
        imageAsset: AppAssets.home,
        imageUrl: firstImageUrl,
        subtitleLine: subtitle,
        rating: rating,
        pricePerDay: pricePerDay,
        currency: d['currency'] as String? ?? '₪',
        lat: lat,
        lng: lng,
        distanceKm: dist,
        tags: tags,
      );
    }).toList()
      ..sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    return result;
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * pow(sin(dLon / 2), 2);

    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degToRad(double deg) => deg * (pi / 180.0);
}
