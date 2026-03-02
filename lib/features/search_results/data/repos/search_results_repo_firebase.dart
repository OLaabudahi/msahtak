import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/filter_chip_entity.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/repos/search_results_repo.dart';

class SearchResultsRepoFirebase implements SearchResultsRepo {
  final FirebaseFirestore _db;

  SearchResultsRepoFirebase({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<List<SpaceEntity>> searchSpaces({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    try {
      final snap = await _db.collection('workspaces').limit(50).get();

      final q = query.trim().toLowerCase();

      final results = snap.docs.map((doc) {
        final d = doc.data();
        final tags = (d['tags'] is List)
            ? (d['tags'] as List).map((e) => e.toString()).toList()
            : <String>[];

        double distanceKm = 0;
        final loc = d['location'];
        if (loc is GeoPoint) {
          distanceKm = _haversineKm(loc.latitude, loc.longitude, 31.7683, 35.2137);
        }

        // استخراج الموقع كـ lat/lng من Map أيضاً
        if (loc is Map && distanceKm == 0) {
          final lat = (loc['latitude'] as num?)?.toDouble();
          final lng = (loc['longitude'] as num?)?.toDouble();
          if (lat != null && lng != null) {
            distanceKm = _haversineKm(lat, lng, 31.7683, 35.2137);
          }
        }

        // استخراج اسم الموقع كـ نص من loc إذا كان string
        String locationName =
            (d['location_name'] ?? d['locationName'] ?? '').toString();
        if (locationName.isEmpty) {
          if (loc is String) locationName = loc;
          else if (loc is Map) {
            locationName = (loc['city'] ?? loc['address'] ?? '').toString();
          }
        }

        // السعر: الأدمن يكتب pricePerHour أو pricing.pricePerDay
        final pricing = d['pricing'] as Map?;
        final priceRaw = d['price_per_day'] ??
            d['pricePerDay'] ??
            pricing?['pricePerDay'] ??
            d['pricePerHour'] ??
            0;
        final pricePerDay =
            (priceRaw is num) ? priceRaw.toDouble() : 0.0;

        // التقييم: stats.averageRating كـ fallback
        final stats = d['stats'] as Map?;
        final rating = (d['rating'] is num)
            ? (d['rating'] as num).toDouble()
            : (stats?['averageRating'] is num)
                ? (stats!['averageRating'] as num).toDouble()
                : 0.0;

        return SpaceEntity(
          id: doc.id,
          name: (d['name'] ?? d['spaceName'] ?? '').toString(),
          locationName: locationName,
          distanceKm: distanceKm,
          pricePerDay: pricePerDay,
          rating: rating,
          tags: tags,
        );
      }).toList();

      if (q.isEmpty) return results;
      return results
          .where((e) =>
              e.name.toLowerCase().contains(q) ||
              e.locationName.toLowerCase().contains(q) ||
              e.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<FilterChipEntity>> getPreferredFilterChips({
    required String originKey,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return [];

      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('preferred_filters')
          .get();

      if (snap.docs.isEmpty) {
        return const [
          FilterChipEntity(id: 'quiet', label: 'Quiet'),
          FilterChipEntity(id: 'wifi_fast', label: 'Fast Wi-Fi'),
          FilterChipEntity(id: 'price_max_40', label: '₪40 max'),
        ];
      }

      return snap.docs.map((doc) {
        final d = doc.data();
        return FilterChipEntity(
          id: (d['id'] ?? doc.id).toString(),
          label: (d['label'] ?? '').toString(),
        );
      }).toList();
    } catch (_) {
      return const [
        FilterChipEntity(id: 'quiet', label: 'Quiet'),
        FilterChipEntity(id: 'wifi_fast', label: 'Fast Wi-Fi'),
        FilterChipEntity(id: 'price_max_40', label: '₪40 max'),
      ];
    }
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);
}
