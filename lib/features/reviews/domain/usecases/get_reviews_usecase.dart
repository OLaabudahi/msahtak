import '../entities/review.dart';
import '../entities/reviews_summary.dart';
import '../repos/reviews_repo.dart';

class GetReviewsUseCase {
  final ReviewsRepo repo;
  GetReviewsUseCase(this.repo);

  /// جلب الملخص والقائمة معاً بفلتر اختياري
  Future<({ReviewsSummary summary, List<Review> reviews})> call(
      {String filter = 'all'}) async {
    final summary = await repo.getReviewsSummary();
    final reviews = await repo.getReviews(filter: filter);
    return (summary: summary, reviews: reviews);
  }
}
