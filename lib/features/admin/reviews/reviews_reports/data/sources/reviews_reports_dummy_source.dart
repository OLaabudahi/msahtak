import 'reviews_reports_source.dart';
import '../models/review_model.dart';
import '../models/report_model.dart';

class ReviewsReportsDummySource implements ReviewsReportsSource {
  // in-memory replies
  final Map<String, String> _replies = {};

  final List<ReviewModel> _baseReviews = [
    const ReviewModel(
      id: 'r1',
      userName: 'Sarah Johnson',
      spaceName: 'Downtown Hub',
      dateLabel: 'Feb 25, 2026',
      stars: '5',
      text: 'Amazing space! Very clean and well-maintained. Great amenities and perfect location.',
      adminReply: null,
    ),
    const ReviewModel(
      id: 'r2',
      userName: 'Mike Chen',
      spaceName: 'Creative Studio',
      dateLabel: 'Feb 24, 2026',
      stars: '4',
      text: 'Good workspace with excellent WiFi. Coffee could be better though.',
      adminReply: null,
    ),
  ];

  @override
  Future<List<ReviewModel>> fetchReviews() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return _baseReviews
        .map((r) => ReviewModel(
      id: r.id,
      userName: r.userName,
      spaceName: r.spaceName,
      dateLabel: r.dateLabel,
      stars: r.stars,
      text: r.text,
      adminReply: _replies[r.id],
    ))
        .toList(growable: false);
  }

  @override
  Future<List<ReportModel>> fetchReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return const [
      ReportModel(id: 'p1', subject: 'Review r2', reason: 'Inappropriate language'),
      ReportModel(id: 'p2', subject: 'User u3', reason: 'Spam activity'),
    ];
  }

  @override
  Future<void> hideReview({required String reviewId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    // (optional) remove reply when hidden
    _replies.remove(reviewId);
  }

  @override
  Future<void> replyReview({required String reviewId, required String reply}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _replies[reviewId] = reply;
  }
}