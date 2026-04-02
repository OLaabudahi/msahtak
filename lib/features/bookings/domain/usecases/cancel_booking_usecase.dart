import '../repos/bookings_repo.dart';

class CancelBookingUseCase {
  final BookingsRepo repo;

  CancelBookingUseCase(this.repo);

  Future<void> call(String bookingId) {
    return repo.cancelBooking(bookingId);
  }
}

