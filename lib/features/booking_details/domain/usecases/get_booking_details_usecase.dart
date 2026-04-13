import '../../data/models/booking_details_model.dart';
import '../repos/booking_details_repo.dart';

class GetBookingDetailsUseCase {
  final BookingDetailsRepo repo;

  GetBookingDetailsUseCase(this.repo);

  Future<BookingDetails> call(String bookingId) {
    return repo.fetchBookingDetails(bookingId);
  }
}
