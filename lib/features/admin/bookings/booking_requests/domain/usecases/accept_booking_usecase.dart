import '../repos/admin_bookings_repo.dart';

class AcceptBookingUseCase {
  final AdminBookingsRepo repo;
  const AcceptBookingUseCase(this.repo);
  Future<void> call({required String bookingId}) => repo.acceptBooking(bookingId: bookingId);
}


