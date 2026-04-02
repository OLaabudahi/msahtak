import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/location_service.dart';
import '../../domain/entities/fit_score.dart';
import '../models/best_for_you_space_model.dart';
import 'best_for_you_remote_source.dart';


class BestForYouFirebaseSource implements BestForYouRemoteSource {
  static const double _fallbackLat = 31.511136495468655;
  static const double _fallbackLng = 34.45187681199389;

  @override
  Future<BestForYouSpaceModel> getBestSpace(String goal) async {
    final top = await getTopRatedNearby();
    if (top.isEmpty) {
      return const BestForYouSpaceModel(
        id: 'unknown',
        name: 'No space found',
        location: '--',
        distance: '--',
        pricePerDay: 0,
        rating: 0,
      );
    }
    return top.first;
  }

  
  @override
  Future<List<BestForYouSpaceModel>> getTopRatedNearby() async {
    final pos = await LocationService.getCurrentPosition();
    final double myLat = pos?.latitude ?? _fallbackLat;
    final double myLng = pos?.longitude ?? _fallbackLng;
    final bool hasRealLocation = pos != null;

    final snap = await FirebaseFirestore.instance
        .collection('spaces')
        .limit(50)
        .get();

    if (snap.docs.isEmpty) return [];

    final all = snap.docs.map((doc) {
      final d = doc.data();

      final loc = d['location'];
      double? lat;
      double? lng;
      if (loc is GeoPoint) {
        lat = loc.latitude;
        lng = loc.longitude;
      } else if (loc is Map) {
        lat = (loc['lat'] as num?)?.toDouble() ??
            (loc['latitude'] as num?)?.toDouble();
        lng = (loc['lng'] as num?)?.toDouble() ??
            (loc['longitude'] as num?)?.toDouble();
      }
      final double distKm =
          (lat != null && lng != null) ? _distanceKm(myLat, myLng, lat, lng) : 999;

      final stats = d['stats'] as Map?;
      final rating = (d['rating'] as num?)?.toDouble() ??
          (stats?['averageRating'] as num?)?.toDouble() ??
          0.0;

      final pricing = d['pricing'] as Map?;
      final pricePerDay = (d['basePriceValue'] as num?)?.toInt() ??
          (d['price_per_day'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          (pricing?['pricePerDay'] as num?)?.toInt() ??
          (d['pricePerHour'] as num?)?.toInt() ??
          0;

      final imageUrls = (d['images'] as List?)?.cast<String>() ?? const [];
      final imageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

      String locationStr = d['subtitle'] as String? ??
          d['location_address'] as String? ??
          d['description'] as String? ??
          '';
      if (locationStr.isEmpty) {
        if (loc is String) locationStr = loc;
        else if (loc is Map) {
          locationStr = (loc['city'] ?? loc['address'] ?? '').toString();
        }
      }
      if (locationStr.isEmpty) locationStr = '--';

      final distStr = distKm < 999
          ? '${(distKm * 1000).toStringAsFixed(0)} m'
          : '--';

      return _SpaceWithDist(
        model: BestForYouSpaceModel(
          id: doc.id,
          name: d['name'] as String? ?? d['spaceName'] as String? ?? 'Space',
          location: locationStr,
          distance: distStr,
          pricePerDay: pricePerDay,
          rating: rating,
          imageUrl: imageUrl,
        ),
        distKm: distKm,
      );
    }).toList();

    
    List<_SpaceWithDist> nearby;
    if (hasRealLocation) {
      nearby = all.where((s) => s.distKm <= 0.1).toList();
      if (nearby.isEmpty) nearby = all; 
    } else {
      nearby = all;
    }

    
    nearby.sort((a, b) => b.model.rating.compareTo(a.model.rating));
    return nearby.take(5).map((s) => s.model).toList();
  }

  @override
  Future<FitScore> getFitScore(String spaceId, String goal) async {
    final doc = await FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .collection('fit_scores')
        .doc(goal.toLowerCase())
        .get();

    if (doc.exists) {
      final d = doc.data()!;
      return FitScore(
        percentage: (d['percentage'] as num?)?.toDouble() ?? 0.8,
        reasons: (d['reasons'] as List?)?.cast<String>() ?? const [],
        headsUp: d['heads_up'] as String? ?? '',
      );
    }

    return switch (goal) {
      'Study' => const FitScore(
          percentage: 0.88,
          reasons: ['Quiet environment', 'Fast Wi-Fi', 'Plenty of outlets'],
          headsUp: 'May get busy in the evenings.',
        ),
      'Work' => const FitScore(
          percentage: 0.82,
          reasons: ['High-speed internet', 'Private desks', 'Good lighting'],
          headsUp: 'Limited parking on weekdays.',
        ),
      'Meeting' => const FitScore(
          percentage: 0.75,
          reasons: ['Conference room', 'Whiteboard', 'Quiet meeting area'],
          headsUp: 'Book meeting rooms in advance.',
        ),
      _ => const FitScore(
          percentage: 0.70,
          reasons: ['Comfortable space', 'Cafأ© nearby'],
          headsUp: '',
        ),
    };
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

class _SpaceWithDist {
  final BestForYouSpaceModel model;
  final double distKm;
  const _SpaceWithDist({required this.model, required this.distKm});
}
