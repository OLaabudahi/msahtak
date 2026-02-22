import 'dart:math';
import '../../domain/entities/geo_point_entity.dart';
import '../models/nearby_space_model.dart';

abstract class NearbySpacesDataSource {
  Future<List<NearbySpaceModel>> fetchNearby({
    required GeoPointEntity center,
    required double radiusKm,
  });
}

class DummyNearbySpacesDataSource implements NearbySpacesDataSource {
  @override
  Future<List<NearbySpaceModel>> fetchNearby({
    required GeoPointEntity center,
    required double radiusKm,
  }) async {
    final all = <_Raw>[
      // ✅ نفس الأماكن اللي بعتيها (IDs لازم تطابق الهوم عندك)
      _Raw(
        id: 'SPACE-001',
        name: 'Downtown Hub',
        subtitle: 'City Center • Quiet • Fast Wi-Fi',
        rating: 4.8,
        imageUrl: 'https://picsum.photos/seed/space001/900/400',
        lat: 31.511605,
        lng: 34.447297,
      ),
      _Raw(
        id: 'SPACE-002',
        name: 'Blue Owl',
        subtitle: 'Cozy • Good lighting • Calm',
        rating: 4.6,
        imageUrl: 'https://picsum.photos/seed/space002/900/400',
        lat: 31.516397477736643,
        lng: 34.4493998718586,
      ),
      _Raw(
        id: 'SPACE-003',
        name: 'Study Nest',
        subtitle: 'Student Friendly • Power Backup',
        rating: 4.7,
        imageUrl: 'https://picsum.photos/seed/space003/900/400',
        lat: 31.522031386576206,
        lng: 34.44729701993432,
      ),
      _Raw(
        id: 'SPACE-004',
        name: 'Private Corner',
        subtitle: 'Private Office • Quiet Zone',
        rating: 4.5,
        imageUrl: 'https://picsum.photos/seed/space004/900/400',
        lat: 31.513233,
        lng: 34.444722,
      ),

      // ✅ أماكن إضافية قريبة (زي ما طلبتي)
      _Raw(
        id: 'SPACE-005',
        name: 'Skyline Desk',
        subtitle: 'Bright • City View • Coffee',
        rating: 4.4,
        imageUrl: 'https://picsum.photos/seed/space005/900/400',
        lat: 31.5102,
        lng: 34.4560,
      ),
      _Raw(
        id: 'SPACE-006',
        name: 'Work & Chill',
        subtitle: 'Relaxed • Meetings • Wi-Fi',
        rating: 4.3,
        imageUrl: 'https://picsum.photos/seed/space006/900/400',
        lat: 31.5079,
        lng: 34.4489,
      ),
    ];

    final models = all.map((s) {
      final d = _distanceKm(center.lat, center.lng, s.lat, s.lng);
      return NearbySpaceModel(
        id: s.id,
        name: s.name,
        subtitle: s.subtitle,
        rating: s.rating,
        imageUrl: s.imageUrl,
        lat: s.lat,
        lng: s.lng,
        distanceKm: d,
      );
    }).toList();

    // ✅ فلترة حسب الراديوس وترتيب بالأقرب
    final filtered = models
        .where((m) => m.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return filtered;
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = pow(sin(dLat / 2), 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _degToRad(double deg) => deg * (pi / 180.0);
}

class _Raw {
  final String id;
  final String name;
  final String subtitle;
  final double rating;
  final String imageUrl;
  final double lat;
  final double lng;

  const _Raw({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.imageUrl,
    required this.lat,
    required this.lng,
  });
}