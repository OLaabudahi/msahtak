import '../entities/kpi_entity.dart';
import '../repos/admin_home_repo.dart';

class GetAdminHomeKpisUseCase {
  final AdminHomeRepo repo;
  const GetAdminHomeKpisUseCase(this.repo);

  Future<List<KpiEntity>> call({required String spaceId}) => repo.getKpis(spaceId: spaceId);
}
