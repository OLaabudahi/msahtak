import 'package:equatable/equatable.dart';

/// âœ… ط±ط³ط§ظ„ط© طھظ†ط¨ظٹظ‡ ط¯ظٹظ†ط§ظ…ظٹظƒظٹط© (Limited availability ط£ظˆ ط؛ظٹط±ظ‡ط§)
class SpaceAlert extends Equatable {
  final String code; // ظ…ط«ط§ظ„: limited_availability / info / warning
  final String title;
  final String message;
  final String colorHex; // ظ…ط«ط§ظ„: #FDE8E8
  final String borderHex; // ظ…ط«ط§ظ„: #FCA5A5
  final String textHex; // ظ…ط«ط§ظ„: #B91C1C

  const SpaceAlert({
    required this.code,
    required this.title,
    required this.message,
    required this.colorHex,
    required this.borderHex,
    required this.textHex,
  });

  /// âœ… (API ط¬ط§ظ‡ط² - ظƒظˆظ…ظ†طھ) ظ…ظ† JSON
  // factory SpaceAlert.fromJson(Map<String, dynamic> json) {
  //   return SpaceAlert(
  //     code: json['code'] ?? '',
  //     title: json['title'] ?? '',
  //     message: json['message'] ?? '',
  //     colorHex: json['colorHex'] ?? '#FDE8E8',
  //     borderHex: json['borderHex'] ?? '#FCA5A5',
  //     textHex: json['textHex'] ?? '#B91C1C',
  //   );
  // }

  @override
  List<Object?> get props => [
    code,
    title,
    message,
    colorHex,
    borderHex,
    textHex,
  ];
}

/// âœ… ط³ظٹط§ط³ط§طھ ط§ظ„ظ…ط³ط§ط­ط© (ظ„ظ€ BottomSheet)
class SpacePolicies extends Equatable {
  final String title;
  final String subtitle;
  final List<PolicySection> sections;

  const SpacePolicies({
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  @override
  List<Object?> get props => [title, subtitle, sections];
}

class PolicySection extends Equatable {
  final String title;
  final List<String> bullets;

  const PolicySection({required this.title, required this.bullets});

  @override
  List<Object?> get props => [title, bullets];
}

/// âœ… Review Summary (ظ„ظ€ BottomSheet)
class ReviewSummary extends Equatable {
  final String header;
  final String meta;
  final List<String> topPositives;
  final List<String> repeatedNegatives;
  final String crowdLevel;
  final String noise;

  const ReviewSummary({
    required this.header,
    required this.meta,
    required this.topPositives,
    required this.repeatedNegatives,
    required this.crowdLevel,
    required this.noise,
  });

  @override
  List<Object?> get props => [
    header,
    meta,
    topPositives,
    repeatedNegatives,
    crowdLevel,
    noise,
  ];
}

/// âœ… ط¢ط®ط± ظ…ط±ط§ط¬ط¹ط§طھ (ظ‚ط³ظ… Latest reviews)
class SpaceReview extends Equatable {
  final String id;
  final String userName;
  final String timeAgo;
  final int stars; // 1..5
  final String comment;

  const SpaceReview({
    required this.id,
    required this.userName,
    required this.timeAgo,
    required this.stars,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, userName, timeAgo, stars, comment];
}

/// âœ… ط¹ط±ظˆط¶ (Offers tab)
class SpaceOffer extends Equatable {
  final String id;
  final String badgeText; // LIMITED / BONUS
  final String badgeType; // limited / bonus (ظ„ظ„ظˆظ†)
  final String title;
  final String priceLine; // "Price:"
  final String? oldPriceText;
  final String newPriceText;
  final String includesText;
  final String validUntilText;

  const SpaceOffer({
    required this.id,
    required this.badgeText,
    required this.badgeType,
    required this.title,
    required this.priceLine,
    required this.oldPriceText,
    required this.newPriceText,
    required this.includesText,
    required this.validUntilText,
  });

  @override
  List<Object?> get props => [
    id,
    badgeText,
    badgeType,
    title,
    priceLine,
    oldPriceText,
    newPriceText,
    includesText,
    validUntilText,
  ];
}

/// âœ… ط¥ط­طµط§ط¦ظٹط§طھ "ظ…ظ† ظٹط³طھط®ط¯ظ… ط§ظ„ظ…ظƒط§ظ† ط¹ط§ط¯ط©"
class UsageStat extends Equatable {
  final String label;
  final int percent; // 0..100

  const UsageStat({required this.label, required this.percent});

  @override
  List<Object?> get props => [label, percent];
}

/// âœ… طھظپط§طµظٹظ„ ط§ظ„ظ…ط³ط§ط­ط© ط§ظ„ط£ط³ط§ط³ظٹط© ط§ظ„ظ„ظٹ ط¨طھط¸ظ‡ط± ظ…ط¨ط§ط´ط±ط© ط¨ط§ظ„ظˆط§ط¬ظ‡ط©
class SpaceDetails extends Equatable {
  final String id;
  final String name;

  final List<String> imageAssets; // ظ‡ظ„ط§ assetsطŒ ظ„ط§ط­ظ‚ط§ظ‹ imageUrls

  final String subtitleLine; // "City Center â€¢ Quiet â€¢ Fast Wi-Fi"
  /// âœ… ظ…ظ‡ظ… ظ„ظ„ظ€ booking logic
  final int pricePerDay;
  final String currency;

  final double rating;
  final int reviewsCount;

  final String workingHours; // "Sun - Thu, 8:00 AM - 10:00 PM"
  final String locationAddress; // "12 King St, Downtown"

  /// âœ… ط§ظ„ط±ط³ط§ظ„ط© ط§ظ„ط¯ظٹظ†ط§ظ…ظٹظƒظٹط© (ظ‚ط¯ طھظƒظˆظ† null)
  final SpaceAlert? alert;

  final List<String> features;

  final List<UsageStat> usageStats;

  final List<String> whyPeopleComeChips;

  final ReviewSummary reviewSummary;
  final List<SpaceReview> latestReviews;

  final List<SpaceOffer> offers;

  final SpacePolicies policies;

  // ط¥ط­ط¯ط§ط«ظٹط§طھ ط§ظ„ظ…ظˆظ‚ط¹ ط§ظ„ط¬ط؛ط±ط§ظپظٹ (ط§ط®طھظٹط§ط±ظٹط§ظ†)
  final double? lat;
  final double? lng;

  /// âœ… (API ط¬ط§ظ‡ط² - ظƒظˆظ…ظ†طھ) from JSON
  // factory SpaceDetails.fromJson(Map<String, dynamic> json) {
  //   return SpaceDetails(
  //     id: json['id'].toString(),
  //     name: json['name'] ?? '',
  //     imageAssets: const [], // ظ„ظˆ assets ظ…ط´ ظ…ظ† API
  //     // ط£ظˆ:
  //     // imageUrls: List<String>.from(json['images'] ?? const []),
  //     priceText: json['priceText'] ?? '',
  //     subtitleLine: json['subtitleLine'] ?? '',
  //     rating: (json['rating'] ?? 0).toDouble(),
  //     reviewsCount: (json['reviewsCount'] ?? 0) as int,
  //     workingHours: json['workingHours'] ?? '',
  //     locationAddress: json['locationAddress'] ?? '',
  //     alert: json['alert'] == null ? null : SpaceAlert.fromJson(json['alert']),
  //     features: List<String>.from(json['features'] ?? const []),
  //     usageStats: (json['usageStats'] as List? ?? const [])
  //         .map((e) => UsageStat(label: e['label'], percent: e['percent']))
  //         .toList(),
  //     whyPeopleComeChips: List<String>.from(json['whyPeopleCome'] ?? const []),
  //     // reviewSummary / latestReviews / offers / policies...
  //   );
  // }
  @override
  List<Object?> get props => [
    id,
    name,
    imageAssets,
    pricePerDay, // âœ…
    currency, // âœ…
    subtitleLine,
    rating,
    reviewsCount,
    workingHours,
    locationAddress,
    alert,
    features,
    usageStats,
    whyPeopleComeChips,
    reviewSummary,
    latestReviews,
    offers,
    policies,
    lat,
    lng,
  ];

  const SpaceDetails({
    required this.id,
    required this.name,
    required this.imageAssets,
    required this.pricePerDay,
    required this.currency,
    required this.subtitleLine,
    required this.rating,
    required this.reviewsCount,
    required this.workingHours,
    required this.locationAddress,
    required this.alert,
    required this.features,
    required this.usageStats,
    required this.whyPeopleComeChips,
    required this.reviewSummary,
    required this.latestReviews,
    required this.offers,
    required this.policies,
    this.lat,
    this.lng,
  });

  /// âœ… (API ط¬ط§ظ‡ط² - ظƒظˆظ…ظ†طھ) from JSON
  // factory SpaceDetails.fromJson(Map<String, dynamic> json) {
  //   return SpaceDetails(
  //     id: json['id'].toString(),
  //     name: json['name'] ?? '',
  //     imageAssets: const [],
  //
  //     // âœ… ط§ظ„ظ…ظ†ط·ظ‚ ط§ظ„طµط­ ظ„ظ„ظ€ API:
  //     pricePerDay: (json['price_per_day'] ?? 0) as int,
  //     currency: json['currency'] ?? 'â‚ھ',
  //
  //     // UI:
  //     priceText: '${json['currency'] ?? 'â‚ھ'}${json['price_per_day'] ?? 0} / day',
  //
  //     subtitleLine: json['subtitleLine'] ?? '',
  //     rating: (json['rating'] ?? 0).toDouble(),
  //     reviewsCount: (json['reviewsCount'] ?? 0) as int,
  //     workingHours: json['workingHours'] ?? '',
  //     locationAddress: json['locationAddress'] ?? '',
  //     alert: json['alert'] == null ? null : SpaceAlert.fromJson(json['alert']),
  //     features: List<String>.from(json['features'] ?? const []),
  //     usageStats: (json['usageStats'] as List? ?? const [])
  //         .map((e) => UsageStat(label: e['label'], percent: e['percent']))
  //         .toList(),
  //     whyPeopleComeChips: List<String>.from(json['whyPeopleCome'] ?? const []),
  //     // reviewSummary / latestReviews / offers / policies...
  //   );
  // }

}


