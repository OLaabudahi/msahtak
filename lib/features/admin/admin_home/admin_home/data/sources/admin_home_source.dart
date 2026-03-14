import '../models/kpi_model.dart';

abstract class AdminHomeSource {
  Future<List<String>> fetchSpaces();
  Future<List<KpiModel>> fetchKpis({required String spaceId});
}
