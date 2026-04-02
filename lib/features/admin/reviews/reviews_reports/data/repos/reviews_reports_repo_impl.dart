import '../../domain/entities/review_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repos/reviews_reports_repo.dart';
import '../sources/reviews_reports_source.dart';

class ReviewsReportsRepoImpl implements ReviewsReportsRepo {
  final ReviewsReportsSource source;
  const ReviewsReportsRepoImpl(this.source);

  @override
  Future<List<ReviewEntity>> getReviews() async => (await source.fetchReviews()).map((m) => m.toEntity()).toList(growable: false);


  Future<List<ReportEntity>> getReports() async => (await source.fetchReports()).map((m) => ReportEntity(id: m.id, subject: m.subject, reason: m.reason)).toList(growable: false);

  @override
  Future<void> hideReview({required String reviewId}) => source.hideReview(reviewId: reviewId);

  @override
  Future<void> replyReview({required String reviewId, required String reply}) => source.replyReview(reviewId: reviewId, reply: reply);
}


