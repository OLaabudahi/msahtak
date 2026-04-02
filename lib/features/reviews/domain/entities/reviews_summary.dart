import 'package:equatable/equatable.dart';

class ReviewsSummary extends Equatable {
  final double overallRating;
  final int totalReviews;

  /// ظ…ظپطھط§ط­ = ط¹ط¯ط¯ ط§ظ„ظ†ط¬ظˆظ… (5,4,3,2,1)طŒ ظ‚ظٹظ…ط© = ط¹ط¯ط¯ ط§ظ„طھظ‚ظٹظٹظ…ط§طھ
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


