import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/fit_score.dart';
import '../models/best_for_you_space_model.dart';
import 'best_for_you_remote_source.dart';

/// ✅ تنفيذ Firebase لـ BestForYouRemoteSource
class BestForYouFirebaseSource implements BestForYouRemoteSource {
  @override
  Future<BestForYouSpaceModel> getBestSpace(String goal) async {
    // نجيب أعلى workspace – نرتب client-side لأن rating قد لا يوجد كـ field مستقل
    final snap = await FirebaseFirestore.instance
        .collection('workspaces')
        .limit(20)
        .get();

    if (snap.docs.isEmpty) {
      return const BestForYouSpaceModel(
        id: 'unknown',
        name: 'No space found',
        location: '--',
        distance: '--',
        pricePerDay: 0,
        rating: 0,
      );
    }

    // نرتب حسب التقييم (top-level أو stats.averageRating)
    final sorted = snap.docs.toList()
      ..sort((a, b) {
        double rA(Map d) {
          final stats = d['stats'] as Map?;
          return (d['rating'] as num?)?.toDouble() ??
              (stats?['averageRating'] as num?)?.toDouble() ??
              0.0;
        }
        return rA(b.data()).compareTo(rA(a.data()));
      });

    final doc = sorted.first;
    final d = doc.data();

    // استخراج اسم الموقع
    final loc = d['location'];
    String locationStr = d['subtitle'] as String? ??
        d['location_address'] as String? ??
        d['description'] as String? ??
        '';
    if (locationStr.isEmpty) {
      if (loc is String) locationStr = loc;
      else if (loc is Map) {
        locationStr = (loc['city'] ?? loc['address'] ?? '').toString();
      }
    }
    if (locationStr.isEmpty) locationStr = '--';

    // السعر
    final pricing = d['pricing'] as Map?;
    final pricePerDay = (d['price_per_day'] as num?)?.toInt() ??
        (d['pricePerDay'] as num?)?.toInt() ??
        (pricing?['pricePerDay'] as num?)?.toInt() ??
        (d['pricePerHour'] as num?)?.toInt() ??
        0;

    // التقييم
    final stats = d['stats'] as Map?;
    final rating = (d['rating'] as num?)?.toDouble() ??
        (stats?['averageRating'] as num?)?.toDouble() ??
        4.0;

    return BestForYouSpaceModel(
      id: doc.id,
      name: d['name'] as String? ?? d['spaceName'] as String? ?? 'Space',
      location: locationStr,
      distance: '--',
      pricePerDay: pricePerDay,
      rating: rating,
    );
  }

  @override
  Future<FitScore> getFitScore(String spaceId, String goal) async {
    // محاولة قراءة fit_scores من subcollection
    final doc = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(spaceId)
        .collection('fit_scores')
        .doc(goal.toLowerCase())
        .get();

    if (doc.exists) {
      final d = doc.data()!;
      return FitScore(
        percentage: (d['percentage'] as num?)?.toDouble() ?? 0.8,
        reasons: (d['reasons'] as List?)?.cast<String>() ?? const [],
        headsUp: d['heads_up'] as String? ?? '',
      );
    }

    // fallback حسب الهدف
    return switch (goal) {
      'Study' => const FitScore(
          percentage: 0.88,
          reasons: ['Quiet environment', 'Fast Wi-Fi', 'Plenty of outlets'],
          headsUp: 'May get busy in the evenings.',
        ),
      'Work' => const FitScore(
          percentage: 0.82,
          reasons: ['High-speed internet', 'Private desks', 'Good lighting'],
          headsUp: 'Limited parking on weekdays.',
        ),
      'Meeting' => const FitScore(
          percentage: 0.75,
          reasons: ['Conference room', 'Whiteboard', 'Quiet meeting area'],
          headsUp: 'Book meeting rooms in advance.',
        ),
      _ => const FitScore(
          percentage: 0.70,
          reasons: ['Comfortable space', 'Café nearby'],
          headsUp: '',
        ),
    };
  }
}
