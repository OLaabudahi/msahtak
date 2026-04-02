/*
import '../../../../constants/app_assets.dart';
import '../models/booking_model.dart';
import '../../domain/repos/bookings_repo.dart';

class BookingsRepoDummy implements BookingsRepo {
  /// âœ… ط¯ط§ظ„ط©: ط¯ط§طھط§ ظˆظ‡ظ…ظٹط© ظ„ظ„ط­ط¬ظˆط²ط§طھ (ط¬ط§ظ‡ط²ط© ظ„ظ„طھط´ط؛ظٹظ„)
  @override
  Future<List<Booking>> fetchBookings() async {
    await Future.delayed(const Duration(milliseconds: 450));

    return const [
      Booking(
        bookingId: 'b_101',
        spaceId: 'space_0',
        spaceName: 'Downtown Hub',
        dateText: 'Mon, 12 Aug',
        timeText: '09:00 - 12:00',
        status: 'upcoming',
        totalPrice: 18.0,
        currency: 'â‚ھ',
        imageAsset: AppAssets.home,
      ),
      Booking(
        bookingId: 'b_102',
        spaceId: 'space_1',
        spaceName: 'City Loft',
        dateText: 'Wed, 14 Aug',
        timeText: '03:00 - 06:00',
        status: 'upcoming',
        totalPrice: 25.0,
        currency: 'â‚ھ',
        imageAsset: AppAssets.home,
      ),
      Booking(
        bookingId: 'b_201',
        spaceId: 'space_2',
        spaceName: 'Private Desk',
        dateText: 'Sun, 04 Aug',
        timeText: '10:00 - 01:00',
        status: 'completed',
        totalPrice: 35.0,
        currency: 'â‚ھ',
        imageAsset: AppAssets.home,
      ),
      Booking(
        bookingId: 'b_301',
        spaceId: 'space_3',
        spaceName: 'Quiet Corner',
        dateText: 'Fri, 02 Aug',
        timeText: '08:00 - 09:00',
        status: 'cancelled',
        totalPrice: 0.0,
        currency: 'â‚ھ',
        imageAsset: AppAssets.home,
      ),
    ];

    // âœ… API READY (ظƒظˆظ…ظ†طھ)
    // final res = await dio.get('/bookings');
    // return (res.data as List).map((e) => Booking.fromJson(e)).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {}
}
*/


