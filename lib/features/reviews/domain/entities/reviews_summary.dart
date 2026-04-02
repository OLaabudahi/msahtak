import 'package:equatable/equatable.dart';

class ReviewsSummary extends Equatable {
  final double overallRating;
  final int totalReviews;

  /// مفتاح = عدد النجوم (5,4,3,2,1)، قيمة = عدد التقييمات
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
