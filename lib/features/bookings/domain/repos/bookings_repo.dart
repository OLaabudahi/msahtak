import '../../data/models/booking_model.dart';

abstract class BookingsRepo {
  Future<List<BookingModel>> fetchBookings();

  Future<BookingModel?> getBookingById(String bookingId);

  Future<void> cancelBooking(String bookingId);

  Stream<List<BookingModel>> listenBookingsUpdates();
}
