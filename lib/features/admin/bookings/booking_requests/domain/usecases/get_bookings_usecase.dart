import '../entities/booking_request_entity.dart';
import '../entities/booking_status.dart';
import '../repos/admin_bookings_repo.dart';

class GetBookingsUseCase {
  final AdminBookingsRepo repo;
  const GetBookingsUseCase(this.repo);
  Future<List<BookingRequestEntity>> call({required BookingStatus status}) => repo.getBookings(status: status);
}
