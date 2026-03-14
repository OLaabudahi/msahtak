import '../entities/review_entity.dart';
import '../repos/reviews_reports_repo.dart';

class GetReviewsUseCase {
  final ReviewsReportsRepo repo;
  const GetReviewsUseCase(this.repo);

  Future<List<ReviewEntity>> call() => repo.getReviews();
}
