import '../entities/booking_entity.dart';
import '../repos/bookings_repo.dart';

class GetBookingsUseCase {
  final BookingsRepo repo;

  GetBookingsUseCase(this.repo);

  Future<List<BookingEntity>> call() {
    return repo.fetchBookings();
  }
}

