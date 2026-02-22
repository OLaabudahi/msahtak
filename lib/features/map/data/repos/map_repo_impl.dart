import '../../domain/entities/geo_point_entity.dart';
import '../../domain/entities/nearby_space_entity.dart';
import '../../domain/repos/map_repo.dart';
import '../sources/location_service.dart';
import '../sources/nearby_spaces_data_source.dart';

class MapRepoImpl implements MapRepo {
  final LocationService locationService;
  final NearbySpacesDataSource dataSource;

  const MapRepoImpl({
    required this.locationService,
    required this.dataSource,
  });

  @override
  Future<GeoPointEntity> getCurrentLocation() => locationService.getCurrentLocation();

  @override
  Future<List<NearbySpaceEntity>> getNearbySpaces({
    required GeoPointEntity center,
    required double radiusKm,
  }) async {
    final models = await dataSource.fetchNearby(center: center, radiusKm: radiusKm);
    return models.map((m) => m.toEntity()).toList();
  }
}