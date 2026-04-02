import 'package:geolocator/geolocator.dart';

/// ط®ط¯ظ…ط© ط§ظ„ظ…ظˆظ‚ط¹ â€“ طھط¹ظٹط¯ ظ…ظˆظ‚ط¹ ط§ظ„ط¬ظ‡ط§ط² ط§ظ„ط­ط§ظ„ظٹ ظ…ط¹ ط§ظ„طھط®ط²ظٹظ† ط§ظ„ظ…ط¤ظ‚طھ
class LocationService {
  static Position? _cached;

  static void clearCache() => _cached = null;

  static Future<Position?> getCurrentPosition() async {
    if (_cached != null) return _cached;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      _cached = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      return _cached;
    } catch (_) {
      return null;
    }
  }
}


