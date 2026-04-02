import '../entities/review.dart';
import '../entities/reviews_summary.dart';

abstract class ReviewsRepo {
  /// ط¬ظ„ط¨ ظ…ظ„ط®طµ ط§ظ„طھظ‚ظٹظٹظ…ط§طھ ط§ظ„ط¥ط¬ظ…ط§ظ„ظٹ
  Future<ReviewsSummary> getReviewsSummary();

  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„طھظ‚ظٹظٹظ…ط§طھ ظ…ط¹ ط¥ظ…ظƒط§ظ†ظٹط© ط§ظ„ظپظ„طھط±ط©
  Future<List<Review>> getReviews({String filter});
}


