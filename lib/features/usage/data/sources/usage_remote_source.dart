import '../models/plan_option_model.dart';
import '../models/usage_stats_model.dart';

/// ظˆط§ط¬ظ‡ط© ظ…طµط¯ط± ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ FakeUsageSource ط¨ظ€ RealUsageSource ط¹ظ†ط¯ ط±ط¨ط· API
abstract class UsageRemoteSource {
  Future<UsageStatsModel> getUsageStats();
  Future<List<PlanOptionModel>> getPlanOptions();
  Future<void> applyPlan(String planId);
}

class FakeUsageSource implements UsageRemoteSource {
  /// ط¬ظ„ط¨ ط¥ط­طµط§ط،ط§طھ ط§ظ„ط§ط³طھط®ط¯ط§ظ… â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/usage/stats') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<UsageStatsModel> getUsageStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const UsageStatsModel(
      totalBookings: 8,
      totalHours: 22,
      avgHoursPerSession: 2.7,
      mostCommonTime: '6â€“10 PM',
      insights: [
        'You often book in the evening.',
        'You prefer places within 2 km.',
      ],
      recommendation:
          'Weekly saves you ~22% vs Daily based on your usage.',
    );
  }

  /// ط¬ظ„ط¨ ط®ظٹط§ط±ط§طھ ط§ظ„ط¨ط§ظ‚ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/plans') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<List<PlanOptionModel>> getPlanOptions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      PlanOptionModel(
          id: 'daily', name: 'Daily', priceLabel: '\$10/day'),
      PlanOptionModel(
          id: 'weekly',
          name: 'Weekly',
          priceLabel: '\$58/week',
          isBest: true),
      PlanOptionModel(
          id: 'monthly',
          name: 'Monthly',
          priceLabel: '\$199/month'),
    ];
  }

  /// طھط·ط¨ظٹظ‚ ط§ظ„ط¨ط§ظ‚ط© â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.post('/plans/apply') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<void> applyPlan(String planId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: POST /api/plans/apply body: {'planId': planId}
  }
}


