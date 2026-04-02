import '../entities/booking_request_entity.dart';
import '../entities/booking_status.dart';

abstract class AdminBookingsRepo {
  Future<List<BookingRequestEntity>> getBookings({required BookingStatus status});
  Future<void> acceptBooking({required String bookingId});
  Future<void> rejectBooking({required String bookingId});
}


