import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../constants/app_assets.dart';
import '../../../../services/location_service.dart';
import '../../domain/entities/home_featured_space_entity.dart';
import '../../domain/entities/insight_item.dart';
import '../../domain/repos/home_repo.dart';
import '../sources/home_firebase_source.dart';

class HomeRepoFirebase implements HomeRepo {
  final HomeSource source;

  HomeRepoFirebase(this.source);

  static const double _fallbackLat = 31.511136495468655;
  static const double _fallbackLng = 34.45187681199389;

  @override
  Future<List<HomeFeaturedSpaceEntity>> getHomeData() async {
    return _buildForYouSpaces();
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

  @override
  Future<List<InsightItem>> getInsights({required String langCode}) async {
    final rows = await source.fetchInsights(langCode: langCode);
    return rows
        .map((d) => InsightItem(
              id: (d['id'] ?? '').toString(),
              title: (d['title'] ?? '').toString(),
              subtitle: (d['subtitle'] ?? '').toString(),
              imageAsset: (d['imageUrl'] ?? '').toString(),
            ))
        .where((e) => e.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<List<HomeFeaturedSpaceEntity>> _buildForYouSpaces() async {
    final allSpaces = await _fetchAllSpaceRecords();
    if (allSpaces.isEmpty) return const [];

    final selected = <HomeFeaturedSpaceEntity>[];
    final selectedIds = <String>{};
    final rnd = Random(DateTime.now().millisecondsSinceEpoch);

    void addIfNotExists(HomeFeaturedSpaceEntity s) {
      if (selectedIds.add(s.id)) selected.add(s);
    }

    // 1) آخر مساحتين تمت إضافتهم
    final latest = [...allSpaces]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    for (final rec in latest.take(2)) {
      addIfNotExists(rec.space);
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final bookings = (uid == null || uid.isEmpty)
        ? <Map<String, dynamic>>[]
        : await source.fetchUserBookings(uid);

    final bookedCounts = <String, int>{};
    for (final row in bookings) {
      final spaceId =
          (row['spaceId'] ?? row['workspaceId'] ?? row['space_id'] ?? '').toString();
      if (spaceId.isEmpty) continue;
      bookedCounts.update(spaceId, (v) => v + 1, ifAbsent: () => 1);
    }

    final bookedRankedIds = bookedCounts.keys.toList(growable: false)
      ..sort((a, b) => (bookedCounts[b] ?? 0).compareTo(bookedCounts[a] ?? 0));

    final byId = {for (final rec in allSpaces) rec.space.id: rec.space};

    // 2) 3-4 مساحات سبق حجزها
    final bookedCandidates = bookedRankedIds
        .where((id) => byId.containsKey(id) && !selectedIds.contains(id))
        .map((id) => byId[id]!)
        .toList(growable: false);

    final bookedTake = bookedCandidates.length >= 4 ? 3 + rnd.nextInt(2) : bookedCandidates.length;
    for (final s in bookedCandidates.take(bookedTake)) {
      addIfNotExists(s);
    }

    // 3) 2-3 مساحات قريبة من المساحة الأكثر حجزاً
    final mostBookedId = bookedRankedIds.isNotEmpty ? bookedRankedIds.first : null;
    final anchor = mostBookedId != null ? byId[mostBookedId] : null;
    if (anchor != null && anchor.lat != null && anchor.lng != null) {
      final nearby = allSpaces
          .map((rec) => rec.space)
          .where((s) => !selectedIds.contains(s.id) && s.lat != null && s.lng != null)
          .toList()
        ..sort((a, b) {
          final da = _distanceKm(anchor.lat!, anchor.lng!, a.lat!, a.lng!);
          final db = _distanceKm(anchor.lat!, anchor.lng!, b.lat!, b.lng!);
          return da.compareTo(db);
        });

      final nearTake = nearby.length >= 3 ? 2 + rnd.nextInt(2) : nearby.length;
      for (final s in nearby.take(nearTake)) {
        addIfNotExists(s);
      }
    }

    // ضمان 6-8 عناصر
    if (selected.length < 6) {
      final rest = allSpaces
          .map((e) => e.space)
          .where((s) => !selectedIds.contains(s.id))
          .toList(growable: false);
      for (final s in rest.take(6 - selected.length)) {
        addIfNotExists(s);
      }
    }

    if (selected.length > 8) {
      return selected.take(8).toList(growable: false);
    }

    return selected;
  }

  Future<List<_SpaceRecord>> _fetchAllSpaceRecords() async {
    final pos = await LocationService.getCurrentPosition();
    final double myLat = pos?.latitude ?? _fallbackLat;
    final double myLng = pos?.longitude ?? _fallbackLng;

    final snap = await source.fetchSpaces();

    return snap.map((d) {
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

      final createdAtRaw = d['createdAt'] ?? d['created_at'];
      final createdAt = _toDateTime(createdAtRaw) ?? DateTime.fromMillisecondsSinceEpoch(0);

      return _SpaceRecord(
        space: HomeFeaturedSpaceEntity(
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
        ),
        createdAt: createdAt,
      );
    }).toList(growable: false);
  }

  Future<List<HomeFeaturedSpaceEntity>> _fetchAllSpaces() async {
    final records = await _fetchAllSpaceRecords();
    final result = records.map((e) => e.space).toList(growable: false)
      ..sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));
    return result;
  }

  DateTime? _toDateTime(dynamic value) {
    try {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      final dyn = value as dynamic;
      final maybe = dyn.toDate();
      if (maybe is DateTime) return maybe;
    } catch (_) {}
    return null;
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

class _SpaceRecord {
  final HomeFeaturedSpaceEntity space;
  final DateTime createdAt;

  const _SpaceRecord({required this.space, required this.createdAt});
}
