import '../models/review_model.dart';
import '../models/reviews_summary_model.dart';

/// ظˆط§ط¬ظ‡ط© ظ…طµط¯ط± ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ FakeReviewsSource ط¨ظ€ RealReviewsSource ط¹ظ†ط¯ ط±ط¨ط· API
abstract class ReviewsRemoteSource {
  Future<ReviewsSummaryModel> getReviewsSummary();
  Future<List<ReviewModel>> getReviews({String filter});
}

class FakeReviewsSource implements ReviewsRemoteSource {
  static const _summary = ReviewsSummaryModel(
    overallRating: 4.6,
    totalReviews: 12,
    ratingBreakdown: {5: 7, 4: 3, 3: 1, 2: 1, 1: 0},
  );

  static const _all = [
    ReviewModel(
      id: '1',
      spaceName: 'Downtown Hub',
      timeAgo: '2 days ago',
      stars: 5,
      text: 'Quiet and clean. Wi-Fi was fast and stable.',
      tags: ['Quiet', 'Fast Wi-Fi'],
      isMine: true,
    ),
    ReviewModel(
      id: '2',
      spaceName: 'City Study Room',
      timeAgo: '1 week ago',
      stars: 4,
      text: 'Great for studying. Seats were limited at peak hours.',
      tags: ['Best for study', 'Good value'],
      isMine: false,
    ),
    ReviewModel(
      id: '3',
      spaceName: 'Creative Zone',
      timeAgo: '2 weeks ago',
      stars: 4,
      text: 'Nice vibe, good for creative work.',
      tags: ['Creative', 'Good atmosphere'],
      isMine: false,
    ),
  ];

  /// ط¬ظ„ط¨ ط§ظ„ظ…ظ„ط®طµ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/reviews/summary') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<ReviewsSummaryModel> getReviewsSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _summary;
  }

  /// ط¬ظ„ط¨ ط§ظ„ظ‚ط§ط¦ظ…ط© ظ…ط¹ ط§ظ„ظپظ„طھط±ط© â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/reviews?filter=X') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<List<ReviewModel>> getReviews({String filter = 'all'}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (filter) {
      case 'mine':
        return _all.where((r) => r.isMine).toList();
      case 'recent':
        return [..._all]..sort((a, b) => a.id.compareTo(b.id));
      default:
        return _all;
    }
  }
}


