import 'package:geolocator/geolocator.dart';

/// خدمة الموقع – تعيد موقع الجهاز الحالي مع التخزين المؤقت
class LocationService {
  static Position? _cached;

  /// إعادة تعيين الموقع المؤقت (للاختبار أو التحديث الإجباري)
  static void clearCache() => _cached = null;

  /// جلب الموقع الحالي للجهاز
  /// تُعيد null إذا رُفضت الصلاحية أو حدث خطأ
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
