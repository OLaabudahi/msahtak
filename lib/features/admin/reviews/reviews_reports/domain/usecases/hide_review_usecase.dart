import '../repos/reviews_reports_repo.dart';

class HideReviewUseCase {
  final ReviewsReportsRepo repo;
  const HideReviewUseCase(this.repo);

  Future<void> call({required String reviewId}) => repo.hideReview(reviewId: reviewId);
}


