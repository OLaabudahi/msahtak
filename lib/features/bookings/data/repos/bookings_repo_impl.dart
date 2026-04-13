import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';
import '../sources/bookings_source.dart';

class BookingsRepoImpl implements BookingsRepo {
  final BookingsSource source;

  BookingsRepoImpl(this.source);

  @override
  Future<List<BookingModel>> fetchBookings() async {
    final data = await source.fetchBookings();
    return data.map(BookingModel.fromMap).toList(growable: false);
  }

  @override
  Future<BookingModel?> getBookingById(String bookingId) async {
    final bookingMap = await source.getBookingById(bookingId);
    if (bookingMap == null) return null;

    final spaceMap = await source.getSpaceById(
      (bookingMap['spaceId'] ?? bookingMap['space_id'] ?? '').toString(),
    );

    return BookingModel.fromMap({
      ...bookingMap,
      if (spaceMap != null) ...{
        'spaceName': bookingMap['spaceName'] ?? bookingMap['workspaceName'] ?? spaceMap['name'],
        'currency': bookingMap['currency'] ?? spaceMap['currency'],
        'totalAmount': bookingMap['totalAmount'] ?? bookingMap['totalPrice'] ?? bookingMap['pricePerDay'] ?? spaceMap['pricePerDay'],
      },
    });
  }

  @override
  Future<void> cancelBooking(String bookingId) {
    return source.cancelBooking(bookingId);
  }

  @override
  Stream<List<BookingModel>> listenBookingsUpdates() {
    return source
        .listenBookingsUpdates()
        .map((rows) => rows.map(BookingModel.fromMap).toList(growable: false));
  }
}
