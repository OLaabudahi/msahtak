abstract class BookingsSource {
  Future<List<Map<String, dynamic>>> fetchBookings();

  Future<void> cancelBooking(String bookingId);
}

