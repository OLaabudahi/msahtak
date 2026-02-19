import '../../data/models/booking_model.dart';

/// ✅ واجهة Repo - عشان وقت API تبدلي implementation بسهولة
abstract class BookingsRepo {
  /// ✅ دالة: تجيب كل الحجوزات (حسب المستخدم)
  Future<List<Booking>> fetchBookings();
}
