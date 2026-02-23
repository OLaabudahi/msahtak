import '../entities/review.dart';
import '../entities/reviews_summary.dart';

abstract class ReviewsRepo {
  /// جلب ملخص التقييمات الإجمالي
  Future<ReviewsSummary> getReviewsSummary();

  /// جلب قائمة التقييمات مع إمكانية الفلترة
  Future<List<Review>> getReviews({String filter});
}
