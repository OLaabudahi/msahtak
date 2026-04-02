import '../entities/review.dart';
import '../entities/reviews_summary.dart';

abstract class ReviewsRepo {
  
  Future<ReviewsSummary> getReviewsSummary();

  
  Future<List<Review>> getReviews({String filter});
}
