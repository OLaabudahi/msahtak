import '../models/review_model.dart';
import '../models/report_model.dart';

abstract class ReviewsReportsSource {
  Future<List<ReviewModel>> fetchReviews();
  Future<List<ReportModel>> fetchReports();
  Future<void> hideReview({required String reviewId});
  Future<void> replyReview({required String reviewId, required String reply});
}


