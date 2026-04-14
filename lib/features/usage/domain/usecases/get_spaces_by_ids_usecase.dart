import '../entities/usage_space_entity.dart';
import '../repos/profile_usage_repo.dart';

class GetSpacesByIdsUseCase {
  final ProfileUsageRepo repo;
  GetSpacesByIdsUseCase(this.repo);

  Future<List<UsageSpaceEntity>> call(List<String> ids) => repo.getSpacesByIds(ids);
}
