import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants/app_assets.dart';
import '../../domain/entities/home_featured_space_entity.dart';
import '../../domain/repos/home_repo.dart';

/// ✅ تنفيذ Firebase لـ HomeRepo – يقرأ workspaces collection
class HomeRepoFirebase implements HomeRepo {
  static const double _meLat = 31.511136495468655;
  static const double _meLng = 34.45187681199389;

  @override
  Future<List<HomeFeaturedSpaceEntity>> fetchForYou() async {
    final snap = await FirebaseFirestore.instance
        .collection('workspaces')
        .limit(20)
        .get();

    final result = snap.docs.map((doc) {
      final d = doc.data();

      // ─── الاسم: الأدمن يكتب spaceName ، التطبيق القديم name ───
      final name = d['name'] as String? ??
          d['spaceName'] as String? ??
          'Space';

      // ─── الوصف الفرعي: الأدمن يكتب description ، وبعض الداتا subtitle ───
      final subtitle = d['subtitle'] as String? ??
          d['subtitleLine'] as String? ??
          d['description'] as String? ??
          '';

      // ─── الموقع: ممكن GeoPoint أو Map {latitude, longitude} أو string ───
      final loc = d['location'];
      double? lat;
      double? lng;
      if (loc is GeoPoint) {
        lat = loc.latitude;
        lng = loc.longitude;
      } else if (loc is Map) {
        lat = (loc['latitude'] as num?)?.toDouble();
        lng = (loc['longitude'] as num?)?.toDouble();
      }
      final double? dist =
          (lat != null && lng != null) ? _distanceKm(_meLat, _meLng, lat, lng) : null;

      // ─── السعر: الأدمن يكتب pricePerHour أو pricing.pricePerDay ───
      final pricing = d['pricing'] as Map<String, dynamic>?;
      final pricePerDay = (d['price_per_day'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          (pricing?['pricePerDay'] as num?)?.toInt() ??
          (pricing?['price_per_day'] as num?)?.toInt() ??
          (d['pricePerHour'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          0;

      // ─── التقييم: الأدمن يخزنه في stats.averageRating أو rating ───
      final stats = d['stats'] as Map<String, dynamic>?;
      final rating = (d['rating'] as num?)?.toDouble() ??
          (stats?['averageRating'] as num?)?.toDouble() ??
          4.0;

      return HomeFeaturedSpaceEntity(
        id: doc.id,
        name: name,
        imageAsset: AppAssets.home,
        subtitleLine: subtitle,
        rating: rating,
        pricePerDay: pricePerDay,
        currency: d['currency'] as String? ?? '₪',
        lat: lat,
        lng: lng,
        distanceKm: dist,
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
