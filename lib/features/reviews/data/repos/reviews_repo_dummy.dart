import '../../domain/entities/review.dart';
import '../../domain/entities/reviews_summary.dart';
import '../../domain/repos/reviews_repo.dart';
import '../sources/reviews_remote_source.dart';

class ReviewsRepoDummy implements ReviewsRepo {
  final ReviewsRemoteSource source;
  ReviewsRepoDummy(this.source);

  /// ط¬ظ„ط¨ ط§ظ„ظ…ظ„ط®طµ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<ReviewsSummary> getReviewsSummary() =>
      source.getReviewsSummary();

  /// ط¬ظ„ط¨ ط§ظ„طھظ‚ظٹظٹظ…ط§طھ ظ…ظ† ط§ظ„ظ…طµط¯ط± ظ…ط¹ ط§ظ„ظپظ„طھط±
  @override
  Future<List<Review>> getReviews({String filter = 'all'}) =>
      source.getReviews(filter: filter);
}


