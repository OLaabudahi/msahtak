import '../../domain/entities/booking_request_entity.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/repos/admin_bookings_repo.dart';
import '../sources/admin_bookings_source.dart';

class AdminBookingsRepoImpl implements AdminBookingsRepo {
  final AdminBookingsSource source;
  const AdminBookingsRepoImpl(this.source);

  @override
  Future<List<BookingRequestEntity>> getBookings({required BookingStatus status}) async {
    final s = switch (status) {
      BookingStatus.awaitingPayment => 'awaiting_payment',
      BookingStatus.awaitingConfirmation => 'awaiting_confirmation',
      BookingStatus.booked => 'booked',
      BookingStatus.canceled => 'canceled',
      BookingStatus.all => 'all',
      _ => 'pending',
    };
    final models = await source.fetchBookings(status: s);
    return models.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> acceptBooking({required String bookingId}) => source.acceptBooking(bookingId: bookingId);

  @override
  Future<void> rejectBooking({required String bookingId}) => source.rejectBooking(bookingId: bookingId);
}
