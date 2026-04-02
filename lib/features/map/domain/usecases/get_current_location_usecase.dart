import '../entities/geo_point_entity.dart';
import '../repos/map_repo.dart';

class GetCurrentLocationUseCase {
  final MapRepo repo;
  const GetCurrentLocationUseCase(this.repo);

  Future<GeoPointEntity> call() => repo.getCurrentLocation();
}
