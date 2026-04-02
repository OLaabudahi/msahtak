import '../../data/models/booking_details_model.dart';


abstract class BookingDetailsRepo {
  
  Future<BookingDetails> fetchBookingDetails(String bookingId);
}
