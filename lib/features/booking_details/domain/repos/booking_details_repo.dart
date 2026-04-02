import '../../data/models/booking_details_model.dart';

/// âœ… ظˆط§ط¬ظ‡ط© Repo (ظˆظ‚طھ ط§ظ„ظ€ API ط¨ط³ ط¨طھط¨ط¯ظ‘ظ„ implementation)
abstract class BookingDetailsRepo {
  /// âœ… طھط¬ظٹط¨ طھظپط§طµظٹظ„ ط§ظ„ط­ط¬ط² ط­ط³ط¨ bookingId
  Future<BookingDetails> fetchBookingDetails(String bookingId);
}


