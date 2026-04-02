import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants/app_assets.dart';
import '../../domain/repos/space_details_repo.dart';
import '../models/space_details_model.dart';


class SpaceDetailsRepoFirebase implements SpaceDetailsRepo {
  @override
  Future<SpaceDetails> fetchSpaceDetails(String spaceId) async {
    final doc = await FirebaseFirestore.instance
        .collection('spaces')
        .doc(spaceId)
        .get();

    final d = doc.data() ?? {};

    
    final name = d['name'] as String? ??
        d['spaceName'] as String? ??
        'Space';

    
    final subtitleLine = d['subtitle'] as String? ??
        d['subtitleLine'] as String? ??
        d['description'] as String? ??
        '';

    
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

    
    final imageUrls = (d['images'] as List?)?.cast<String>() ?? const [];
    final imageAssets =
        imageUrls.isEmpty ? [AppAssets.home, AppAssets.home] : <String>[];

    
    final features = (d['features'] as List?)?.cast<String>() ?? const [];

    
    
    final amenitiesRaw = (d['amenities'] as List?) ?? const [];
    final amenities = amenitiesRaw
        .where((e) => e is Map)
        .map((e) => (e as Map)['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    
    final usageStatsList = (d['usage_stats'] as List?) ?? const [];
    final usageStats = usageStatsList
        .map((e) => UsageStat(
              label: e['label'] as String? ?? '',
              percent: (e['percent'] as num?)?.toInt() ?? 0,
            ))
        .toList();

    
    final whyPeopleCome =
        (d['why_people_come'] as List?)?.cast<String>() ?? const [];

    
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

    
    
    final policiesObj = d['policies'];
    final policiesMap = (policiesObj is Map)
        ? policiesObj.cast<String, dynamic>()
        : <String, dynamic>{};

    
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


String _parseWorkingHours(Map<String, dynamic> d) {
  final raw = d['workingHours'] ?? d['working_hours'];

  
  if (raw is String) return raw.isNotEmpty ? raw : '--';

  
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
