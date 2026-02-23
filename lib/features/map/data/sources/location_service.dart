import '../../domain/entities/geo_point_entity.dart';

abstract class LocationService {
  Future<GeoPointEntity> getCurrentLocation();
}

class DummyLocationService implements LocationService {
  final GeoPointEntity fixed;

  DummyLocationService({required this.fixed});

  @override
  Future<GeoPointEntity> getCurrentLocation() async => fixed;
}