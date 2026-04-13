import '../../data/models/booking_model.dart';
import '../repos/bookings_repo.dart';

class GetBookingByIdUseCase {
  final BookingsRepo repo;

  GetBookingByIdUseCase(this.repo);

  Future<BookingModel?> call(String bookingId) {
    return repo.getBookingById(bookingId);
  }
}
