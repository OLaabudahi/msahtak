import '../entities/kpi_entity.dart';

abstract class AdminHomeRepo {
  Future<List<KpiEntity>> getKpis({required String spaceId});
  Future<List<String>> getSpaces(); // returns space IDs (or names)
}
