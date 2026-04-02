import '../../domain/entities/review.dart';
import '../../domain/entities/reviews_summary.dart';
import '../../domain/repos/reviews_repo.dart';
import '../sources/reviews_remote_source.dart';

class ReviewsRepoDummy implements ReviewsRepo {
  final ReviewsRemoteSource source;
  ReviewsRepoDummy(this.source);

  /// جلب الملخص من المصدر
  @override
  Future<ReviewsSummary> getReviewsSummary() =>
      source.getReviewsSummary();

  /// جلب التقييمات من المصدر مع الفلتر
  @override
  Future<List<Review>> getReviews({String filter = 'all'}) =>
      source.getReviews(filter: filter);
}
