import '../repos/booking_details_repo.dart';

class CancelBookingUseCase {
  final BookingDetailsRepo repo;

  CancelBookingUseCase(this.repo);

  Future<void> call(String bookingId) {
    return repo.cancelBooking(bookingId);
  }
}
