import '../../domain/entities/booking_entity.dart';
import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';
import '../sources/bookings_source.dart';

class BookingsRepoImpl implements BookingsRepo {
  final BookingsSource source;

  BookingsRepoImpl(this.source);

  @override
  Future<List<BookingEntity>> fetchBookings() async {
    final data = await source.fetchBookings();

    return data.map((e) => BookingModel.fromMap(e)).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await source.cancelBooking(bookingId);
  }
}

