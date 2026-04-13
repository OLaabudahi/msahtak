import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

import '../../domain/entities/filter_chip_entity.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/repos/search_results_repo.dart';
import '../sources/search_results_remote_source.dart';

class SearchResultsRepoFirebase implements SearchResultsRepo {
  final SearchResultsRemoteSource source;

  SearchResultsRepoFirebase({required this.source});

  @override
  Future<List<SpaceEntity>> searchSpaces({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    final docs = await source.searchSpacesRaw(
      query: query,
      selectedFilters: selectedFilters,
      originKey: originKey,
    );

    final q = query.trim().toLowerCase();

    final results = docs.map((d) {
      final tags = (d['tags'] is List)
          ? (d['tags'] as List).map((e) => e.toString()).toList(growable: false)
          : <String>[];

      final amenities = (d['amenities'] is List)
          ? (d['amenities'] as List).map((e) => e.toString()).toList(growable: false)
          : <String>[];

      final paymentMethodsRaw = (d['paymentMethods'] as List?) ?? const [];
      final paymentMethods = paymentMethodsRaw
          .map((e) => e is Map ? (e['name'] ?? e['id'] ?? '').toString() : e.toString())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);

      final workingHours = (d['workingHours'] is Map)
          ? Map<String, dynamic>.from(d['workingHours'] as Map)
          : <String, dynamic>{};

      final loc = d['location'];
      double distanceKm = 0;
      if (loc is GeoPoint) {
        distanceKm = _haversineKm(loc.latitude, loc.longitude, 31.7683, 35.2137);
      } else if (loc is Map) {
        final lat = (loc['latitude'] as num?)?.toDouble() ?? (loc['lat'] as num?)?.toDouble();
        final lng = (loc['longitude'] as num?)?.toDouble() ?? (loc['lng'] as num?)?.toDouble();
        if (lat != null && lng != null) {
          distanceKm = _haversineKm(lat, lng, 31.7683, 35.2137);
        }
      }

      final imagesList = (d['images'] as List?)?.cast<String>() ?? const [];
      final imageUrl = imagesList.isNotEmpty
          ? imagesList.first
          : (d['imageUrl'] as String? ?? d['cover'] as String? ?? d['thumbnailUrl'] as String?);

      return SpaceEntity(
        id: d['id'].toString(),
        name: (d['name'] ?? d['spaceName'] ?? '').toString(),
        locationName: (d['locationAddress'] ?? d['address'] ?? d['location_name'] ?? d['city'] ?? '').toString(),
        distanceKm: distanceKm,
        pricePerDay: ((d['basePriceValue'] ?? d['pricePerDay'] ?? 0) as num).toDouble(),
        rating: ((d['rating'] ?? 0) as num).toDouble(),
        tags: tags,
        imageUrl: imageUrl,
        workingHours: workingHours,
        amenities: amenities,
        paymentMethods: paymentMethods,
        totalSeats: ((d['totalSeats'] ?? 0) as num).toInt(),
        currentBookings: ((d['currentBookings'] ?? d['bookedSeats'] ?? 0) as num).toInt(),
      );
    }).toList(growable: false);

    if (q.isEmpty) return results;
    return results
        .where((e) =>
            e.name.toLowerCase().contains(q) ||
            e.locationName.toLowerCase().contains(q) ||
            e.tags.any((t) => t.toLowerCase().contains(q)))
        .toList(growable: false);
  }

  @override
  Future<List<FilterChipEntity>> getPreferredFilterChips({required String originKey}) async {
    final raw = await source.preferredChipsRaw(originKey: originKey);
    if (raw.isEmpty) return const [];
    return raw
        .map((d) => FilterChipEntity(id: (d['id'] ?? '').toString(), label: (d['label'] ?? '').toString()))
        .toList(growable: false);
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
