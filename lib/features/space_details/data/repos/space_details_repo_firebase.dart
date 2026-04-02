import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants/app_assets.dart';
import '../../domain/repos/space_details_repo.dart';
import '../models/space_details_model.dart';

/// âœ… طھظ†ظپظٹط° Firebase ظ„ظ€ SpaceDetailsRepo â€“ ظٹظ‚ط±ط£ spaces/{id}
class SpaceDetailsRepoFirebase implements SpaceDetailsRepo {
  @override
  Future<SpaceDetails> fetchSpaceDetails(String spaceId) async {
    final doc = await FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .get();

    final d = doc.data() ?? {};

    // â”€â”€â”€ ط§ظ„ط§ط³ظ…: ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ spaceName â”€â”€â”€
    final name = d['name'] as String? ??
        d['spaceName'] as String? ??
        'Space';

    // â”€â”€â”€ ط§ظ„ظˆطµظپ ط§ظ„ظپط±ط¹ظٹ: ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ description â”€â”€â”€
    final subtitleLine = d['subtitle'] as String? ??
        d['subtitleLine'] as String? ??
        d['description'] as String? ??
        '';

    // â”€â”€â”€ ط§ظ„ط³ط¹ط±: ط§ظ„ط£ط¯ظ…ظ† ظٹظƒطھط¨ pricePerHour ط£ظˆ pricing.pricePerDay â”€â”€â”€
    final pricing = d['pricing'] as Map<String, dynamic>?;
    final pricePerDay = (d['basePriceValue'] as num?)?.toInt() ??
        (d['price_per_day'] as num?)?.toInt() ??
        (d['pricePerDay'] as num?)?.toInt() ??
        (pricing?['pricePerDay'] as num?)?.toInt() ??
        (pricing?['price_per_day'] as num?)?.toInt() ??
        (d['pricePerHour'] as num?)?.toInt() ??
        0;

    // â”€â”€â”€ ط§ظ„طھظ‚ظٹظٹظ…: ط§ظ„ط£ط¯ظ…ظ† ظٹط®ط²ظ†ظ‡ ظپظٹ stats.averageRating â”€â”€â”€
    final stats = d['stats'] as Map<String, dynamic>?;
    final rating = (d['rating'] as num?)?.toDouble() ??
        (stats?['averageRating'] as num?)?.toDouble() ??
        4.0;

    // â”€â”€â”€ ط¹ظ†ظˆط§ظ† ط§ظ„ظ…ظˆظ‚ط¹ + ط¥ط­ط¯ط§ط«ظٹط§طھ â”€â”€â”€
    final loc = d['location'];
    String locationAddress = d['location_address'] as String? ??
        d['locationAddress'] as String? ??
        d['address'] as String? ??
        '';
    if (locationAddress.isEmpty) {
      if (loc is String) {
        locationAddress = loc;
      } else if (loc is Map) {
        final city = loc['city'] as String? ?? '';
        final addr = loc['address'] as String? ?? '';
        locationAddress = [addr, city].where((s) => s.isNotEmpty).join(', ');
      }
    }
    if (locationAddress.isEmpty) locationAddress = '--';

    // ط§ط³طھط®ط±ط§ط¬ ط§ظ„ط¥ط­ط¯ط§ط«ظٹط§طھ ط§ظ„ط¬ط؛ط±ط§ظپظٹط©
    double? spaceLat;
    double? spaceLng;
    if (loc is GeoPoint) {
      spaceLat = loc.latitude;
      spaceLng = loc.longitude;
    } else if (loc is Map) {
      spaceLat = (loc['lat'] as num?)?.toDouble() ??
          (loc['latitude'] as num?)?.toDouble();
      spaceLng = (loc['lng'] as num?)?.toDouble() ??
          (loc['longitude'] as num?)?.toDouble();
    }

    // ط§ظ„طµظˆط±
    final imageUrls = (d['images'] as List?)?.cast<String>() ?? const [];
    final imageAssets =
        imageUrls.isEmpty ? [AppAssets.home, AppAssets.home] : <String>[];

    // ط§ظ„ظ€ features
    final features = (d['features'] as List?)?.cast<String>() ?? const [];

    // ط§ظ„ظ€ amenities ظƒظ€ features ط¥ط¶ط§ظپظٹط© ط¥ط°ط§ ظپط´ features
    // ط§ظ„ط£ط¯ظ…ظ† ظٹط­ظپط¸ظ‡ط§ ظƒظ€ List<Map> ظ…ط¹ {id, name, selected, isCustom}
    final amenitiesRaw = (d['amenities'] as List?) ?? const [];
    final amenities = amenitiesRaw
        .where((e) => e is Map)
        .map((e) => (e as Map)['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    // ط¥ط­طµط§ط،ط§طھ ط§ظ„ط§ط³طھط®ط¯ط§ظ…
    final usageStatsList = (d['usage_stats'] as List?) ?? const [];
    final usageStats = usageStatsList
        .map((e) => UsageStat(
              label: e['label'] as String? ?? '',
              percent: (e['percent'] as num?)?.toInt() ?? 0,
            ))
        .toList();

    // why people come
    final whyPeopleCome =
        (d['why_people_come'] as List?)?.cast<String>() ?? const [];

    // review summary
    final rsMap = d['review_summary'] as Map<String, dynamic>? ?? {};
    final reviewSummary = ReviewSummary(
      header: rsMap['header'] as String? ?? '$rating âک…',
      meta: rsMap['meta'] as String? ?? '',
      topPositives: (rsMap['top_positives'] as List?)?.cast<String>() ?? const [],
      repeatedNegatives:
          (rsMap['repeated_negatives'] as List?)?.cast<String>() ?? const [],
      crowdLevel: rsMap['crowd_level'] as String? ?? 'Moderate',
      noise: rsMap['noise'] as String? ?? '--',
    );

    // latest reviews
    final reviewsList = (d['latest_reviews'] as List?) ?? const [];
    final latestReviews = reviewsList
        .map((e) => SpaceReview(
              id: e['id'] as String? ?? '',
              userName: e['user_name'] as String? ?? 'User',
              timeAgo: e['time_ago'] as String? ?? '',
              stars: (e['stars'] as num?)?.toInt() ?? 5,
              comment: e['comment'] as String? ?? '',
            ))
        .toList();

    // offers
    final offersList = (d['offers'] as List?) ?? const [];
    final offers = offersList
        .map((e) => SpaceOffer(
              id: e['id'] as String? ?? '',
              badgeText: e['badge_text'] as String? ?? 'LIMITED',
              badgeType: e['badge_type'] as String? ?? 'limited',
              title: e['title'] as String? ?? '',
              priceLine: e['price_line'] as String? ?? 'Price:',
              oldPriceText: e['old_price_text'] as String?,
              newPriceText: e['new_price_text'] as String? ?? '',
              includesText: e['includes_text'] as String? ?? '',
              validUntilText: e['valid_until_text'] as String? ?? '',
            ))
        .toList();

    // policies â€” ط§ظ„ط£ط¯ظ…ظ† ظٹط­ظپط¸ policySections ظƒظ€ List<Map> ظ…ط¹ {id, title, bullets}
    // d['policies'] ظ‚ط¯ ظٹظƒظˆظ† String (ط­ظ‚ظ„ ظ‚ط¯ظٹظ…) ط£ظˆ Map ط£ظˆ null â€” ظ†طھط¬ط§ظ‡ظ„ ط§ظ„ظ€ String
    final policiesObj = d['policies'];
    final policiesMap = (policiesObj is Map)
        ? policiesObj.cast<String, dynamic>()
        : <String, dynamic>{};

    // ظ†ظ‚ط±ط£ ظ…ظ† policySections (ط­ظ‚ظ„ ط§ظ„ط£ط¯ظ…ظ†) ط£ظˆ policies.sections (ط­ظ‚ظ„ ظ‚ط¯ظٹظ…)
    final rawSections = (d['policySections'] as List?)
        ?? (policiesMap['sections'] as List?)
        ?? const [];

    final policies = SpacePolicies(
      title: policiesMap['title'] as String? ?? 'House Rules',
      subtitle: policiesMap['subtitle'] as String? ?? '',
      sections: rawSections
          .where((s) => s is Map)
          .map((s) {
            final m = s as Map;
            return PolicySection(
              title: m['title']?.toString() ?? '',
              bullets: (m['bullets'] as List?)
                      ?.map((b) => b.toString())
                      .toList() ??
                  const [],
            );
          })
          .toList(),
    );

    return SpaceDetails(
      id: spaceId,
      name: name,
      imageAssets: imageUrls.isNotEmpty ? imageUrls : imageAssets,
      subtitleLine: subtitleLine,
      pricePerDay: pricePerDay,
      currency: d['currency'] as String? ?? 'â‚ھ',
      rating: rating,
      reviewsCount: (d['reviews_count'] as num?)?.toInt() ??
          (d['reviewsCount'] as num?)?.toInt() ??
          (stats?['reviewCount'] as num?)?.toInt() ??
          0,
      workingHours: _parseWorkingHours(d),
      locationAddress: locationAddress,
      alert: null,
      features: features.isNotEmpty ? features : amenities,
      usageStats: usageStats,
      whyPeopleComeChips: whyPeopleCome,
      reviewSummary: reviewSummary,
      latestReviews: latestReviews,
      offers: offers,
      policies: policies,
      lat: spaceLat,
      lng: spaceLng,
    );
  }
}

/// طھط­ظˆظٹظ„ workingHours ظ…ظ† Firestore ط¥ظ„ظ‰ ظ†طµ ظ‚ط§ط¨ظ„ ظ„ظ„ط¹ط±ط¶
String _parseWorkingHours(Map<String, dynamic> d) {
  final raw = d['workingHours'] ?? d['working_hours'];

  // ظ†طµ ط¬ط§ظ‡ط²
  if (raw is String) return raw.isNotEmpty ? raw : '--';

  // ظ‚ط§ط¦ظ…ط© Map ظ…ظ† ط§ظ„ط£ط¯ظ…ظ†: [{day, open, close, closed}, ...]
  if (raw is List) {
    final open = raw.where((e) => e is Map && e['closed'] != true);
    if (open.isEmpty) return 'Closed';
    return open.map((e) {
      final m = e as Map;
      return '${m['day'] ?? ''}  ${m['open'] ?? ''} - ${m['close'] ?? ''}';
    }).join('\n');
  }

  return '--';
}


