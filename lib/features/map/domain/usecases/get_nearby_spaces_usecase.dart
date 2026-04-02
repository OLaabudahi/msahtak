import '../entities/geo_point_entity.dart';
import '../entities/nearby_space_entity.dart';
import '../repos/map_repo.dart';

class GetNearbySpacesUseCase {
  final MapRepo repo;
  const GetNearbySpacesUseCase(this.repo);

  Future<List<NearbySpaceEntity>> call({
    required GeoPointEntity center,
    required double radiusKm,
  }) {
    return repo.getNearbySpaces(center: center, radiusKm: radiusKm);
  }
}
