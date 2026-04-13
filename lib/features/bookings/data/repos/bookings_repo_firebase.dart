import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';
import '../sources/bookings_firebase_source.dart';

class BookingsRepoFirebase implements BookingsRepo {
  final BookingsFirebaseSource source;

  BookingsRepoFirebase(this.source);

  @override
  Future<List<BookingModel>> fetchBookings() async {
    final rows = await source.fetchBookings();
    return rows.map(BookingModel.fromMap).toList(growable: false);
  }

  @override
  Future<BookingModel?> getBookingById(String bookingId) async {
    final row = await source.getBookingById(bookingId);
    if (row == null) return null;
    return BookingModel.fromMap(row);
  }

  @override
  Future<void> cancelBooking(String bookingId) => source.cancelBooking(bookingId);

  @override
  Stream<List<BookingModel>> listenBookingsUpdates() {
    return source
        .listenBookingsUpdates()
        .map((rows) => rows.map(BookingModel.fromMap).toList(growable: false));
  }
}
