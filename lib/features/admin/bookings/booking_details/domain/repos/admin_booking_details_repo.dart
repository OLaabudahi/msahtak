import '../entities/booking_details_entity.dart';

abstract class AdminBookingDetailsRepo {
  Future<BookingDetailsEntity> getBookingDetails({required String bookingId});
  Future<void> confirmBooking({required String bookingId});
  Future<void> cancelBooking({required String bookingId, required String reason});
}
