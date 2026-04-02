import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'reviews_reports_source.dart';
import '../models/review_model.dart';
import '../models/report_model.dart';


class ReviewsReportsFirebaseSource implements ReviewsReportsSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<ReviewModel>> fetchReviews() async {
    final snap = await _db
        .collection('reviews')
        .where('hidden', isNotEqualTo: true)
        .get();

    return snap.docs.map((doc) {
      final d = doc.data();
      return ReviewModel(
        id: doc.id,
        userName: d['userName'] as String? ?? 'User',
        spaceName: d['spaceName'] as String? ?? '',
        dateLabel: _formatDate(d['createdAt']),
        stars: (d['rating'] ?? d['stars'] ?? '5').toString(),
        text: d['text'] as String? ?? d['comment'] as String? ?? '',
        adminReply: d['adminReply'] as String?,
      );
    }).toList();
  }

  @override
  Future<List<ReportModel>> fetchReports() async {
    final snap = await _db.collection('reports').get();
    return snap.docs.map((doc) {
      final d = doc.data();
      return ReportModel(
        id: doc.id,
        subject: d['subject'] as String? ?? '',
        reason: d['reason'] as String? ?? '',
      );
    }).toList();
  }

  @override
  Future<void> hideReview({required String reviewId}) async {
    await _db.collection('reviews').doc(reviewId).update({'hidden': true});
  }

  @override
  Future<void> replyReview({
    required String reviewId,
    required String reply,
  }) async {
    await _db.collection('reviews').doc(reviewId).update({
      'adminReply': reply,
      'repliedAt': FieldValue.serverTimestamp(),
    });
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return '-';
    try {
      final dt = (ts as Timestamp).toDate();
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return '-';
    }
  }
}
