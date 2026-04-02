import '../entities/review.dart';
import '../entities/reviews_summary.dart';
import '../repos/reviews_repo.dart';

class GetReviewsUseCase {
  final ReviewsRepo repo;
  GetReviewsUseCase(this.repo);

  /// ط¬ظ„ط¨ ط§ظ„ظ…ظ„ط®طµ ظˆط§ظ„ظ‚ط§ط¦ظ…ط© ظ…ط¹ط§ظ‹ ط¨ظپظ„طھط± ط§ط®طھظٹط§ط±ظٹ
  Future<({ReviewsSummary summary, List<Review> reviews})> call(
      {String filter = 'all'}) async {
    final summary = await repo.getReviewsSummary();
    final reviews = await repo.getReviews(filter: filter);
    return (summary: summary, reviews: reviews);
  }
}


