import 'package:equatable/equatable.dart';

class UsageOfferInsight extends Equatable {
  final String spaceId;
  final String spaceName;
  final String bestPlan;
  final int savings;
  final String offerTitle;
  final int basePricePerDay;

  const UsageOfferInsight({
    required this.spaceId,
    required this.spaceName,
    required this.bestPlan,
    required this.savings,
    required this.offerTitle,
    required this.basePricePerDay,
  });

  @override
  List<Object?> get props =>
      [spaceId, spaceName, bestPlan, savings, offerTitle, basePricePerDay];
}

class UsageInsightEntity extends Equatable {
  final int totalBookings;
  final int dailyCount;
  final int weeklyCount;
  final int monthlyCount;
  final String mostUsedPlan;
  final String favoriteSpaceId;
  final String userType;
  final bool repeatsSameSpace;
  final int estimatedSpending;
  final int estimatedSavings;
  final String recommendedPlan;
  final UsageOfferInsight? bestOffer;

  const UsageInsightEntity({
    required this.totalBookings,
    required this.dailyCount,
    required this.weeklyCount,
    required this.monthlyCount,
    required this.mostUsedPlan,
    required this.favoriteSpaceId,
    required this.userType,
    required this.repeatsSameSpace,
    required this.estimatedSpending,
    required this.estimatedSavings,
    required this.recommendedPlan,
    required this.bestOffer,
  });

  factory UsageInsightEntity.empty() => const UsageInsightEntity(
        totalBookings: 0,
        dailyCount: 0,
        weeklyCount: 0,
        monthlyCount: 0,
        mostUsedPlan: 'daily',
        favoriteSpaceId: '',
        userType: 'flexible',
        repeatsSameSpace: false,
        estimatedSpending: 0,
        estimatedSavings: 0,
        recommendedPlan: 'daily',
        bestOffer: null,
      );

  @override
  List<Object?> get props => [
        totalBookings,
        dailyCount,
        weeklyCount,
        monthlyCount,
        mostUsedPlan,
        favoriteSpaceId,
        userType,
        repeatsSameSpace,
        estimatedSpending,
        estimatedSavings,
        recommendedPlan,
        bestOffer,
      ];
}
