import '../models/hub_model.dart';
import '../models/weekly_plan_model.dart';

/// واجهة مصدر البيانات – استبدل FakeWeeklyPlanSource بـ RealWeeklyPlanSource عند ربط API
abstract class WeeklyPlanRemoteSource {
  Future<List<HubModel>> getHubs();
  Future<WeeklyPlanModel> getPlanDetails(String hubId);
  Future<void> activatePlan(String hubId);
}

class FakeWeeklyPlanSource implements WeeklyPlanRemoteSource {
  static const _hubs = [
    HubModel(id: 'h1', name: 'DownTown Hub'),
    HubModel(id: 'h2', name: 'Space A'),
    HubModel(id: 'h3', name: 'Creative Zone'),
  ];

  static const _plans = {
    'h1': WeeklyPlanModel(
      hubId: 'h1',
      hubName: 'DownTown Hub',
      pricePerWeek: 200,
      features: [
        'Unlimited check-ins',
        'Priority availability',
        'High-speed Wi-Fi',
        'Better value for frequent visits',
      ],
      tip:
          'Tip: If you book 7+ days often, weekly is usually cheaper than daily.',
    ),
    'h2': WeeklyPlanModel(
      hubId: 'h2',
      hubName: 'Space A',
      pricePerWeek: 175,
      features: [
        'Unlimited check-ins',
        'Quiet study environment',
        'High-speed Wi-Fi',
        'Priority seat reservation',
      ],
      tip:
          'Tip: Space A tends to be quieter on weekday mornings.',
    ),
    'h3': WeeklyPlanModel(
      hubId: 'h3',
      hubName: 'Creative Zone',
      pricePerWeek: 220,
      features: [
        'Unlimited check-ins',
        'Creative tools & whiteboards',
        'High-speed Wi-Fi',
        'Access to event space',
      ],
      tip:
          'Tip: Creative Zone hosts free workshops on Saturdays.',
    ),
  };

  /// جلب قائمة المساحات – استبدل بـ http.get('/hubs') عند ربط API
  @override
  Future<List<HubModel>> getHubs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _hubs;
  }

  /// جلب تفاصيل الخطة – استبدل بـ http.get('/weekly-plan/$hubId') عند ربط API
  @override
  Future<WeeklyPlanModel> getPlanDetails(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _plans[hubId] ?? _plans['h1']!;
  }

  /// تفعيل الخطة – استبدل بـ http.post('/weekly-plan/activate') عند ربط API
  @override
  Future<void> activatePlan(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: POST /api/weekly-plan/activate body: {'hubId': hubId}
  }
}
