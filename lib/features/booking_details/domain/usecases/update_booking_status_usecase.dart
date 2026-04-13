import '../repos/booking_details_repo.dart';

class UpdateBookingStatusUseCase {
  final BookingDetailsRepo repo;

  UpdateBookingStatusUseCase(this.repo);

  Future<void> call({
    required String bookingId,
    required String status,
  }) {
    return repo.updateBookingStatus(bookingId: bookingId, status: status);
  }
}
