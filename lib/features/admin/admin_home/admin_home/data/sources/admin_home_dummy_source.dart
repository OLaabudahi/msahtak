import 'admin_home_source.dart';
import '../models/kpi_model.dart';

class AdminHomeDummySource implements AdminHomeSource {
  @override
  Future<List<String>> fetchSpaces() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return const ['Downtown Hub', 'Creative Studio', 'Tech Center'];
  }

  @override
  Future<List<KpiModel>> fetchKpis({required String spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return const [
      KpiModel(id: 'today', title: 'Today Bookings', value: '12', delta: '+2 vs yesterday'),
      KpiModel(id: 'pending', title: 'Pending Requests', value: '5', delta: 'Needs review'),
      KpiModel(id: 'occupancy', title: 'Occupancy Now', value: '78%', delta: '+6%'),
      KpiModel(id: 'revenue', title: 'Weekly Revenue', value: '\$1,240', delta: '+12%'),
    ];
  }
}

