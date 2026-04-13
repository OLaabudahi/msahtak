import '../../../../constants/app_assets.dart';
import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';

class BookingsRepoDummy implements BookingsRepo {
  @override
  Future<List<BookingModel>> fetchBookings() async {
    await Future.delayed(const Duration(milliseconds: 450));

    return [
      BookingModel(
        bookingId: 'b_101',
        spaceId: 'space_0',
        spaceName: 'Downtown Hub',
        dateText: 'Mon, 12 Aug',
        timeText: '09:00 - 12:00',
        status: 'upcoming',
        rawStatus: 'upcoming',
        totalPrice: 18.0,
        currency: '₪',
        imageUrl: AppAssets.home,
      ),
      BookingModel(
        bookingId: 'b_102',
        spaceId: 'space_1',
        spaceName: 'City Loft',
        dateText: 'Wed, 14 Aug',
        timeText: '03:00 - 06:00',
        status: 'upcoming',
        rawStatus: 'upcoming',
        totalPrice: 25.0,
        currency: '₪',
        imageUrl: AppAssets.home,
      ),
      BookingModel(
        bookingId: 'b_201',
        spaceId: 'space_2',
        spaceName: 'Private Desk',
        dateText: 'Sun, 04 Aug',
        timeText: '10:00 - 01:00',
        status: 'completed',
        rawStatus: 'completed',
        totalPrice: 35.0,
        currency: '₪',
        imageUrl: AppAssets.home,
      ),
      BookingModel(
        bookingId: 'b_301',
        spaceId: 'space_3',
        spaceName: 'Quiet Corner',
        dateText: 'Fri, 02 Aug',
        timeText: '08:00 - 09:00',
        status: 'cancelled',
        rawStatus: 'cancelled',
        totalPrice: 0.0,
        currency: '₪',
        imageUrl: AppAssets.home,
      ),
    ];
  }

  @override
  Future<BookingModel?> getBookingById(String bookingId) async {
    final items = await fetchBookings();
    for (final item in items) {
      if (item.bookingId == bookingId) return item;
    }
    return null;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {}

  @override
  Stream<List<BookingModel>> listenBookingsUpdates() async* {
    yield await fetchBookings();
  }
}
