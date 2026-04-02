import '../entities/booking_entity.dart';

abstract class BookingsRepo {
  Future<List<BookingEntity>> fetchBookings();

  Future<void> cancelBooking(String bookingId);
}

