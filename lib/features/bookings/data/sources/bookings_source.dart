abstract class BookingsSource {
  Future<List<Map<String, dynamic>>> fetchBookings();

  Future<Map<String, dynamic>?> getBookingById(String bookingId);

  Future<Map<String, dynamic>?> getSpaceById(String spaceId);

  Future<void> cancelBooking(String bookingId);

  Stream<List<Map<String, dynamic>>> listenBookingsUpdates();
}
