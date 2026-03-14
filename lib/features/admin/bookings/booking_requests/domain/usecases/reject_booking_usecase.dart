import '../repos/admin_bookings_repo.dart';

class RejectBookingUseCase {
  final AdminBookingsRepo repo;
  const RejectBookingUseCase(this.repo);
  Future<void> call({required String bookingId}) => repo.rejectBooking(bookingId: bookingId);
}
