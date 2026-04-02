import '../entities/booking_request_entity.dart';
import '../repos/booking_request_repo.dart';

class GetBookingRequestStatusUseCase {
  final BookingRequestRepo repo;

  const GetBookingRequestStatusUseCase(this.repo);

  Future<BookingRequestEntity> call(String requestId) {
    return repo.getStatus(requestId: requestId);
  }
}
