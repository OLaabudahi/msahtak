import '../entities/booking_request_entity.dart';
import '../repos/booking_request_repo.dart';

class CancelBookingRequestUseCase {
  final BookingRequestRepo repo;

  const CancelBookingRequestUseCase(this.repo);

  Future<BookingRequestEntity> call({
    required String bookingId,
    required String reason,
  }) {
    return repo.cancel(bookingId: bookingId, reason: reason);
  }
}

