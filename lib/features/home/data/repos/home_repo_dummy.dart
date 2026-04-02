import 'dart:async';
import 'dart:math';

import '../../domain/entities/home_featured_space_entity.dart';
import '../../domain/repos/home_repo.dart';

class HomeRepoDummy implements HomeRepo {
  
  static const double _meLat = 31.511136495468655;
  static const double _meLng = 34.45187681199389;

  @override
  Future<List<HomeFeaturedSpaceEntity>> fetchForYou() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    
    final raw = <_RawSpace>[
      _RawSpace(
        id: 'SPACE-001',
        name: 'Downtown Hub',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'City Center â€¢ Quiet â€¢ Fast Wi-Fi',
        rating: 4.8,
        pricePerDay: 35,
        currency: 'â‚ھ',
        lat: 31.511605,
        lng: 34.447297,
      ),
      _RawSpace(
        id: 'SPACE-002',
        name: 'Blue Owl',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'Cozy â€¢ Good lighting â€¢ Calm',
        rating: 4.6,
        pricePerDay: 45,
        currency: 'â‚ھ',
        lat: 31.516397477736643,
        lng: 34.4493998718586,
      ),
      _RawSpace(
        id: 'SPACE-003',
        name: 'Study Nest',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'Student Friendly â€¢ Power Backup',
        rating: 4.7,
        pricePerDay: 30,
        currency: 'â‚ھ',
        lat: 31.522031386576206,
        lng: 34.44729701993432,
      ),
      _RawSpace(
        id: 'SPACE-004',
        name: 'Private Corner',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'Private Office â€¢ Quiet Zone',
        rating: 4.5,
        pricePerDay: 55,
        currency: 'â‚ھ',
        lat: 31.513233,
        lng: 34.444722,
      ),

      
      _RawSpace(
        id: 'SPACE-005',
        name: 'Skyline Desk',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'Bright â€¢ City View â€¢ Coffee',
        rating: 4.4,
        pricePerDay: 40,
        currency: 'â‚ھ',
        lat: 31.5102,
        lng: 34.4560,
      ),
      _RawSpace(
        id: 'SPACE-006',
        name: 'Work & Chill',
        imageAsset: 'assets/images/home.png',
        subtitleLine: 'Relaxed â€¢ Meetings â€¢ Wi-Fi',
        rating: 4.3,
        pricePerDay: 38,
        currency: 'â‚ھ',
        lat: 31.5079,
        lng: 34.4489,
      ),
    ];

    final entities = raw
        .map((s) {
      final d = _distanceKm(_meLat, _meLng, s.lat, s.lng);
      return HomeFeaturedSpaceEntity(
        id: s.id,
        name: s.name,
        imageAsset: s.imageAsset,
        subtitleLine: s.subtitleLine,
        rating: s.rating,
        pricePerDay: s.pricePerDay,
        currency: s.currency,
        lat: s.lat,
        lng: s.lng,
        distanceKm: d,
      );
    })
        .toList()
      ..sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    return entities;

    
    
    
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

class _RawSpace {
  final String id;
  final String name;
  final String imageAsset;
  final String subtitleLine;
  final double rating;
  final int pricePerDay;
  final String currency;
  final double lat;
  final double lng;

  const _RawSpace({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.subtitleLine,
    required this.rating,
    required this.pricePerDay,
    required this.currency,
    required this.lat,
    required this.lng,
  });
}
