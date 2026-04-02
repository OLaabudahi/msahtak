import '../repos/admin_booking_details_repo.dart';

class ConfirmBookingUseCase {
  final AdminBookingDetailsRepo repo;
  const ConfirmBookingUseCase(this.repo);

  Future<void> call({required String bookingId}) {
    return repo.confirmBooking(bookingId: bookingId);
  }
}


