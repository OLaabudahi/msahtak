import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/plan_option_model.dart';
import '../models/usage_stats_model.dart';
import 'usage_remote_source.dart';


class UsageFirebaseSource implements UsageRemoteSource {
  @override
  Future<UsageStatsModel> getUsageStats() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return _defaultStats();

    
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final d = doc.data() ?? {};
    final stats = d['stats'] as Map<String, dynamic>?;

    if (stats != null) {
      return UsageStatsModel(
        totalBookings: (stats['total_bookings'] as num?)?.toInt() ?? 0,
        totalHours: (stats['total_hours'] as num?)?.toInt() ?? 0,
        avgHoursPerSession:
            (stats['avg_hours_per_session'] as num?)?.toDouble() ?? 0,
        mostCommonTime: stats['most_common_time'] as String? ?? '--',
        insights: (stats['insights'] as List?)?.cast<String>() ?? const [],
        recommendation: stats['recommendation'] as String? ?? '',
      );
    }

    
    final snap = await FirebaseFirestore.instance
        .collection('bookings')
        .where('user_id', isEqualTo: uid)
        .get();
    final total = snap.docs.length;

    return UsageStatsModel(
      totalBookings: total,
      totalHours: total * 2,
      avgHoursPerSession: 2.0,
      mostCommonTime: '--',
      insights: total > 0
          ? ['You have made $total bookings so far.']
          : ['No bookings yet.'],
      recommendation: total >= 5
          ? 'Weekly plan could save you money based on your usage.'
          : 'Start booking to see personalised insights.',
    );
  }

  @override
  Future<List<PlanOptionModel>> getPlanOptions() async {
    final snap = await FirebaseFirestore.instance
        .collection('plans')
        .orderBy('order')
        .get();

    if (snap.docs.isEmpty) {
      return const [
        PlanOptionModel(id: 'daily', name: 'Daily', priceLabel: 'â‚ھ10/day'),
        PlanOptionModel(
            id: 'weekly', name: 'Weekly', priceLabel: 'â‚ھ58/week', isBest: true),
        PlanOptionModel(
            id: 'monthly', name: 'Monthly', priceLabel: 'â‚ھ199/month'),
      ];
    }

    return snap.docs.map((doc) {
      final d = doc.data();
      return PlanOptionModel(
        id: doc.id,
        name: d['name'] as String? ?? doc.id,
        priceLabel: d['price_label'] as String? ?? '',
        isBest: d['is_best'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  Future<void> applyPlan(String planId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'active_plan': planId});
  }

  UsageStatsModel _defaultStats() => const UsageStatsModel(
        totalBookings: 0,
        totalHours: 0,
        avgHoursPerSession: 0,
        mostCommonTime: '--',
        insights: [],
        recommendation: '',
      );
}
