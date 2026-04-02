import 'package:equatable/equatable.dart';

class ReviewsSummary extends Equatable {
  final double overallRating;
  final int totalReviews;

  
  final Map<int, int> ratingBreakdown;

  const ReviewsSummary({
    required this.overallRating,
    required this.totalReviews,
    required this.ratingBreakdown,
  });

  @override
  List<Object?> get props =>
      [overallRating, totalReviews, ratingBreakdown];
}
