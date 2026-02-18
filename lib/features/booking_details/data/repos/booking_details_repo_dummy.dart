import '../../../../constants/app_assets.dart';
import '../models/booking_details_model.dart';
import 'booking_details_repo.dart';

/// ✅ Dummy repo (شغال هلا) - جاهز للـ API لاحقاً
class BookingDetailsRepoDummy implements BookingDetailsRepo {
  @override
  Future<BookingDetails> fetchBookingDetails(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return BookingDetails(
      bookingId: bookingId,
      spaceName: 'Downtown Hub',
      rating: 4.8,
      locationText: 'City Center',
      tags: const ['Quiet', 'Fast Wi-Fi'],
      imageAsset: AppAssets.home,
      imageUrl: null,
      dateText: 'Mon, 12 Aug',
      timeText: '09:00 - 12:00',
      guestsCount: 1,
      totalPrice: 18.0,
      currency: 'USD',
      notes: 'يرجى توفير مقعد قريب من الشباك إذا أمكن.',
    );

    // ✅ API READY (كومنت)
    // final res = await dio.get('/bookings/$bookingId');
    // return BookingDetails.fromJson(res.data);
  }
}
