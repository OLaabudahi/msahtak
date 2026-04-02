import '../models/booking_request_model.dart';

abstract class AdminBookingsSource {
  Future<List<BookingRequestModel>> fetchBookings({required String status});
  Future<void> acceptBooking({required String bookingId});
  Future<void> rejectBooking({required String bookingId});
}


