import 'analytics_source.dart';
import '../models/analytics_model.dart';

class AnalyticsDummySource implements AnalyticsSource {
  @override
  Future<AnalyticsModel> fetchAnalytics() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return const AnalyticsModel(
      occupancy: '72%',
      revenue: '\$4,820',
      avgRating: '4.6',
      weekLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      weekValues: ['12', '18', '10', '22', '30', '16', '14'],
      topSpaces: ['Downtown Hub', 'Creative Studio', 'Tech Center'],
    );
  }

  @override
  Future<void> exportReport() async => Future<void>.delayed(const Duration(milliseconds: 180));
}


