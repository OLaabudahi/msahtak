import '../../data/models/booking_details_model.dart';

abstract class BookingDetailsRepo {
  Future<BookingDetails> fetchBookingDetails(String bookingId);

  Future<void> cancelBooking(String bookingId);

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  });
}
