import '../repos/admin_booking_details_repo.dart';

class CancelBookingUseCase {
  final AdminBookingDetailsRepo repo;
  const CancelBookingUseCase(this.repo);

  Future<void> call({required String bookingId, required String reason}) {
    return repo.cancelBooking(bookingId: bookingId, reason: reason);
  }
}
