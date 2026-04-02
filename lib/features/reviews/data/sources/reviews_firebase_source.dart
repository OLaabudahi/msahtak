import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/review_model.dart';
import '../models/reviews_summary_model.dart';
import 'reviews_remote_source.dart';

/// âœ… طھظ†ظپظٹط° Firebase ظ„ظ€ ReviewsRemoteSource
class ReviewsFirebaseSource implements ReviewsRemoteSource {
  @override
  Future<ReviewsSummaryModel> getReviewsSummary() async {
    final snap = await FirebaseFirestore.instance
        .collection('reviews')
        .limit(100)
        .get();

    if (snap.docs.isEmpty) {
      return const ReviewsSummaryModel(
        overallRating: 0,
        totalReviews: 0,
        ratingBreakdown: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      );
    }

    final ratings = snap.docs.map((d) => (d['stars'] as num?)?.toInt() ?? 0).toList();
    final total = ratings.length;
    final avg = ratings.fold<int>(0, (a, b) => a + b) / total;
    final breakdown = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in ratings) {
      breakdown[r] = (breakdown[r] ?? 0) + 1;
    }

    return ReviewsSummaryModel(
      overallRating: double.parse(avg.toStringAsFixed(1)),
      totalReviews: total,
      ratingBreakdown: breakdown,
    );
  }

  @override
  Future<List<ReviewModel>> getReviews({String filter = 'all'}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final snap = await FirebaseFirestore.instance
        .collection('reviews')
        .orderBy('created_at', descending: true)
        .limit(50)
        .get();

    var list = snap.docs.map((doc) {
      final d = doc.data();
      final ts = d['created_at'] as Timestamp?;
      return ReviewModel(
        id: doc.id,
        spaceName: d['space_name'] as String? ?? d['spaceName'] as String? ?? 'Space',
        timeAgo: _relativeTime(ts),
        stars: (d['stars'] as num?)?.toInt() ?? 5,
        text: d['comment'] as String? ?? d['text'] as String? ?? '',
        tags: (d['tags'] as List?)?.cast<String>() ?? const [],
        isMine: uid != null && (d['user_id'] as String?) == uid,
      );
    }).toList();

    if (filter == 'mine') {
      list = list.where((r) => r.isMine).toList();
    }

    return list;
  }

  String _relativeTime(Timestamp? ts) {
    if (ts == null) return '--';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return '1 day ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 14) return '1 week ago';
    return '${(diff.inDays / 7).round()} weeks ago';
  }
}


