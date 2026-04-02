import '../../../../services/location_service.dart' as svc;
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

/// يستخدم GPS الحقيقي للجهاز مع fallback للإحداثيات الثابتة
class GeolocatorLocationService implements LocationService {
  static const double _fallbackLat = 31.511136495468655;
  static const double _fallbackLng = 34.45187681199389;

  @override
  Future<GeoPointEntity> getCurrentLocation() async {
    final pos = await svc.LocationService.getCurrentPosition();
    if (pos != null) {
      return GeoPointEntity(lat: pos.latitude, lng: pos.longitude);
    }
    return const GeoPointEntity(lat: _fallbackLat, lng: _fallbackLng);
  }
}