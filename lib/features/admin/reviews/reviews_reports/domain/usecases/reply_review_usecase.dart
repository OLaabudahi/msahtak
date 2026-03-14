import '../repos/reviews_reports_repo.dart';

class ReplyReviewUseCase {
  final ReviewsReportsRepo repo;
  const ReplyReviewUseCase(this.repo);

  Future<void> call({required String reviewId, required String reply}) => repo.replyReview(reviewId: reviewId, reply: reply);
}
