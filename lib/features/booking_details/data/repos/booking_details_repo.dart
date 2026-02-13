import '../models/booking_details_model.dart';

/// ✅ واجهة Repo (وقت الـ API بس بتبدّل implementation)
abstract class BookingDetailsRepo {
  /// ✅ تجيب تفاصيل الحجز حسب bookingId
  Future<BookingDetails> fetchBookingDetails(String bookingId);
}
