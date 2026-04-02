import '../entities/geo_point_entity.dart';
import '../entities/nearby_space_entity.dart';

abstract class MapRepo {
  Future<GeoPointEntity> getCurrentLocation();

  Future<List<NearbySpaceEntity>> getNearbySpaces({
    required GeoPointEntity center,
    required double radiusKm,
  });
}
