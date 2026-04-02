/*
import 'dart:async';

import '../../../../constants/app_assets.dart';
import '../../../bookings/data/repos/bookings_repo_dummy.dart';
import '../models/booking_details_model.dart';
import '../../domain/repos/booking_details_repo.dart';

class BookingDetailsRepoDummy implements BookingDetailsRepo {
  BookingDetailsRepoDummy();

  final BookingsRepoDummy _bookingsRepo = BookingsRepoDummy();

  @override
  Future<BookingDetails> fetchBookingDetails(String bookingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    // âœ… API READY (comment)
    // final res = await dio.get('/bookings/$bookingId');
    // return BookingDetails.fromJson(res.data);

    // âœ… ظ†ط¬ظٹط¨ ظ†ظپط³ ظ‚ط§ط¦ظ…ط© ط§ظ„ط­ط¬ظˆط²ط§طھ ط§ظ„ظˆظ‡ظ…ظٹط© ظˆظ†ط·ظ„ط¹ ظ…ظ†ظ‡ط§ ط§ظ„ط­ط¬ط² ط§ظ„ظ…ط·ظ„ظˆط¨
    final all = await _bookingsRepo.fetchBookings();
    final matches = all.where((b) => b.bookingId == bookingId).toList();

    if (matches.isEmpty) {
      return BookingDetails(
        bookingId: bookingId,
        spaceId: 'S-UNKNOWN',
        spaceName: 'Space',
        rating: 4.2,
        locationText: 'Unknown location',
        tags: const ['Wi-Fi', 'Quiet'],
        dateText: 'â€”',
        timeText: 'â€”',
        notes: 'No details found for this booking.',
        totalPrice: 0,
        currency: 'â‚ھ',
        imageAsset: AppAssets.home,
      );
    }

    final b = matches.first;

    // âœ… ظ†ظˆظ„ظ‘ط¯ طھظپط§طµظٹظ„ ظˆظ‡ظ…ظٹط© â€œظ…ظ†ط·ظ‚ظٹط©â€‌ ط­ط³ط¨ ط§ظ„ط­ط§ظ„ط©
    final status = b.status.toLowerCase();

    final notes = switch (status) {
      'upcoming' =>
        'Please arrive 10 minutes early. Reception will guide you to the room.',
      'completed' =>
        'Thanks for visiting! You can rebook the same space anytime.',
      'cancelled' =>
        'This booking was cancelled. If you need help, contact support.',
      _ => 'No extra notes.',
    };

    final tags = switch (b.spaceId) {
      'space_0' => const ['Quiet', 'Fast Wi-Fi', 'Projector', 'Parking'],
      'space_1' => const ['Air conditioning', 'Coffee', 'Whiteboard'],
      'space_2' => const ['Meeting room', 'Silent zone', 'City view'],
      'space_3' => const ['Quiet', 'Flexible hours', 'Near center'],
      _ => const ['Wi-Fi', 'Quiet'],
    };

    final locationText = switch (b.spaceId) {
      'space_0' => 'Gaza, Al-Rimal â€¢ 1.2 km',
      'space_1' => 'Gaza, Tel Al-Hawa â€¢ 2.8 km',
      'space_2' => 'Gaza, Al-Nasr â€¢ 0.9 km',
      'space_3' => 'Gaza, Al-Shati â€¢ 3.1 km',
      _ => 'Gaza',
    };

    final rating = switch (b.spaceId) {
      'space_0' => 4.7,
      'space_1' => 4.5,
      'space_2' => 4.9,
      'space_3' => 4.3,
      _ => 4.2,
    };

    return BookingDetails(
      bookingId: b.bookingId,
      spaceId: b.spaceId,
      spaceName: b.spaceName,
      rating: rating,
      locationText: locationText,
      tags: tags,
      dateText: b.dateText,
      timeText: b.timeText,
      notes: notes,
      totalPrice: b.totalPrice,
      currency: b.currency,
      imageAsset: b.imageAsset ?? AppAssets.home,
      imageUrl: b.imageUrl,

      // âœ… API READY (comment)
      // imageUrl: b.imageUrl,
    );
  }
}
*/


