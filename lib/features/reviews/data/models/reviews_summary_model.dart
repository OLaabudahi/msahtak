import '../../domain/entities/reviews_summary.dart';

class ReviewsSummaryModel extends ReviewsSummary {
  const ReviewsSummaryModel({
    required super.overallRating,
    required super.totalReviews,
    required super.ratingBreakdown,
  });

  factory ReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    final breakdown = (json['ratingBreakdown'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(int.parse(k), v as int));
    return ReviewsSummaryModel(
      overallRating: (json['overallRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      ratingBreakdown: breakdown,
    );
  }
}


