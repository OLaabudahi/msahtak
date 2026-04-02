import '../models/booking_details_model.dart';

abstract class AdminBookingDetailsSource {
  Future<BookingDetailsModel> fetchBookingDetails({required String bookingId});
  Future<void> confirmBooking({required String bookingId});
  Future<void> cancelBooking({required String bookingId, required String reason});
}


