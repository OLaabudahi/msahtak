import 'package:equatable/equatable.dart';

/// ✅ رسالة تنبيه ديناميكية (Limited availability أو غيرها)
class SpaceAlert extends Equatable {
  final String code; // مثال: limited_availability / info / warning
  final String title;
  final String message;
  final String colorHex; // مثال: #FDE8E8
  final String borderHex; // مثال: #FCA5A5
  final String textHex; // مثال: #B91C1C

  const SpaceAlert({
    required this.code,
    required this.title,
    required this.message,
    required this.colorHex,
    required this.borderHex,
    required this.textHex,
  });

  /// ✅ (API جاهز - كومنت) من JSON
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

/// ✅ سياسات المساحة (لـ BottomSheet)
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

/// ✅ Review Summary (لـ BottomSheet)
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

/// ✅ آخر مراجعات (قسم Latest reviews)
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

/// ✅ عروض (Offers tab)
class SpaceOffer extends Equatable {
  final String id;
  final String badgeText; // LIMITED / BONUS
  final String badgeType; // limited / bonus (للون)
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

/// ✅ إحصائيات "من يستخدم المكان عادة"
class UsageStat extends Equatable {
  final String label;
  final int percent; // 0..100

  const UsageStat({required this.label, required this.percent});

  @override
  List<Object?> get props => [label, percent];
}

/// ✅ تفاصيل المساحة الأساسية اللي بتظهر مباشرة بالواجهة
class SpaceDetails extends Equatable {
  final String id;
  final String name;

  final List<String> imageAssets; // هلا assets، لاحقاً imageUrls

  final String subtitleLine; // "City Center • Quiet • Fast Wi-Fi"
  /// ✅ مهم للـ booking logic
  final int pricePerDay;
  final String currency;

  final double rating;
  final int reviewsCount;

  final String workingHours; // "Sun - Thu, 8:00 AM - 10:00 PM"
  final String locationAddress; // "12 King St, Downtown"

  /// ✅ الرسالة الديناميكية (قد تكون null)
  final SpaceAlert? alert;

  final List<String> features;

  final List<UsageStat> usageStats;

  final List<String> whyPeopleComeChips;

  final ReviewSummary reviewSummary;
  final List<SpaceReview> latestReviews;

  final List<SpaceOffer> offers;

  final SpacePolicies policies;

  // إحداثيات الموقع الجغرافي (اختياريان)
  final double? lat;
  final double? lng;

  /// ✅ (API جاهز - كومنت) from JSON
  // factory SpaceDetails.fromJson(Map<String, dynamic> json) {
  //   return SpaceDetails(
  //     id: json['id'].toString(),
  //     name: json['name'] ?? '',
  //     imageAssets: const [], // لو assets مش من API
  //     // أو:
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
    pricePerDay, // ✅
    currency, // ✅
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

  /// ✅ (API جاهز - كومنت) from JSON
  // factory SpaceDetails.fromJson(Map<String, dynamic> json) {
  //   return SpaceDetails(
  //     id: json['id'].toString(),
  //     name: json['name'] ?? '',
  //     imageAssets: const [],
  //
  //     // ✅ المنطق الصح للـ API:
  //     pricePerDay: (json['price_per_day'] ?? 0) as int,
  //     currency: json['currency'] ?? '₪',
  //
  //     // UI:
  //     priceText: '${json['currency'] ?? '₪'}${json['price_per_day'] ?? 0} / day',
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
