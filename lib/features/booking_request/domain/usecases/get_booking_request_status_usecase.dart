import '../entities/booking_request_entity.dart';
import '../repos/booking_request_repo.dart';

class GetBookingRequestStatusUseCase {
  final BookingRequestRepo repo;

  const GetBookingRequestStatusUseCase(this.repo);

  Future<BookingRequestEntity> call(String bookingId) {
    return repo.getStatus(bookingId: bookingId);
  }
}


