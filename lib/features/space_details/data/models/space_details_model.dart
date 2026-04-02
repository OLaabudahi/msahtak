import 'package:equatable/equatable.dart';


class SpaceAlert extends Equatable {
  final String code; 
  final String title;
  final String message;
  final String colorHex; 
  final String borderHex; 
  final String textHex; 

  const SpaceAlert({
    required this.code,
    required this.title,
    required this.message,
    required this.colorHex,
    required this.borderHex,
    required this.textHex,
  });

  
  
  
  
  
  
  
  
  
  
  

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


class SpaceReview extends Equatable {
  final String id;
  final String userName;
  final String timeAgo;
  final int stars; 
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


class SpaceOffer extends Equatable {
  final String id;
  final String badgeText; 
  final String badgeType; 
  final String title;
  final String priceLine; 
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


class UsageStat extends Equatable {
  final String label;
  final int percent; 

  const UsageStat({required this.label, required this.percent});

  @override
  List<Object?> get props => [label, percent];
}


class SpaceDetails extends Equatable {
  final String id;
  final String name;

  final List<String> imageAssets; 

  final String subtitleLine; 
  
  final int pricePerDay;
  final String currency;

  final double rating;
  final int reviewsCount;

  final String workingHours; 
  final String locationAddress; 

  
  final SpaceAlert? alert;

  final List<String> features;

  final List<UsageStat> usageStats;

  final List<String> whyPeopleComeChips;

  final ReviewSummary reviewSummary;
  final List<SpaceReview> latestReviews;

  final List<SpaceOffer> offers;

  final SpacePolicies policies;

  
  final double? lat;
  final double? lng;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  @override
  List<Object?> get props => [
    id,
    name,
    imageAssets,
    pricePerDay, 
    currency, 
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

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

}
