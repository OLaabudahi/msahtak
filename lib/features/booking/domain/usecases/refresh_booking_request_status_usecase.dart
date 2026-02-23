import '../entities/booking_request_entity.dart';
import '../repos/booking_request_repo.dart';

class RefreshBookingRequestStatusUseCase {
  final BookingRequestRepo repo;

  const RefreshBookingRequestStatusUseCase(this.repo);

  Future<BookingRequestEntity> call(String requestId) {
    return repo.refreshStatus(requestId: requestId);
  }
}
