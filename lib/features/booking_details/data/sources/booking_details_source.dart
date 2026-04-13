abstract class BookingDetailsSource {
  Future<Map<String, dynamic>?> getBookingById(String bookingId);

  Future<Map<String, dynamic>?> getSpaceById(String spaceId);

  Future<void> cancelBooking(String bookingId);

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  });
}
