
import '../../data/models/booking_model.dart';


abstract class BookingsRepo {
  
  Future<List<Booking>> fetchBookings();

  
  Future<void> cancelBooking(String bookingId);
}
