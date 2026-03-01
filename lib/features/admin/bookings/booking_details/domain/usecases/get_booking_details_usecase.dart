import '../entities/booking_details_entity.dart';
import '../repos/admin_booking_details_repo.dart';

class GetBookingDetailsUseCase {
  final AdminBookingDetailsRepo repo;
  const GetBookingDetailsUseCase(this.repo);

  Future<BookingDetailsEntity> call({required String bookingId}) {
    return repo.getBookingDetails(bookingId: bookingId);
  }
}
