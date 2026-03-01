import '../../domain/entities/booking_details_entity.dart';
import '../../domain/repos/admin_booking_details_repo.dart';
import '../sources/admin_booking_details_source.dart';

class AdminBookingDetailsRepoImpl implements AdminBookingDetailsRepo {
  final AdminBookingDetailsSource source;
  const AdminBookingDetailsRepoImpl(this.source);

  @override
  Future<BookingDetailsEntity> getBookingDetails({required String bookingId}) async {
    final m = await source.fetchBookingDetails(bookingId: bookingId);
    return m.toEntity();
  }

  @override
  Future<void> confirmBooking({required String bookingId}) {
    return source.confirmBooking(bookingId: bookingId);
  }

  @override
  Future<void> cancelBooking({required String bookingId, required String reason}) {
    return source.cancelBooking(bookingId: bookingId, reason: reason);
  }
}
