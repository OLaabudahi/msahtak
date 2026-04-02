import '../models/plan_option_model.dart';
import '../models/usage_stats_model.dart';


abstract class UsageRemoteSource {
  Future<UsageStatsModel> getUsageStats();
  Future<List<PlanOptionModel>> getPlanOptions();
  Future<void> applyPlan(String planId);
}

class FakeUsageSource implements UsageRemoteSource {
  
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

  
  @override
  Future<void> applyPlan(String planId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
