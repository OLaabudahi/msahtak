import '../entities/review_entity.dart';
import '../entities/report_entity.dart';

abstract class ReviewsReportsRepo {
  Future<List<ReviewEntity>> getReviews();
  Future<List<ReportEntity>> getReports();
  Future<void> hideReview({required String reviewId});
  Future<void> replyReview({required String reviewId, required String reply});
}
