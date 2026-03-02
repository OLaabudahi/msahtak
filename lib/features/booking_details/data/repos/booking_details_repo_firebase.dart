import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants/app_assets.dart';
import '../../domain/repos/booking_details_repo.dart';
import '../models/booking_details_model.dart';

/// ✅ تنفيذ Firebase لـ BookingDetailsRepo
class BookingDetailsRepoFirebase implements BookingDetailsRepo {
  @override
  Future<BookingDetails> fetchBookingDetails(String bookingId) async {
    final bookingDoc = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .get();

    if (!bookingDoc.exists) {
      return BookingDetails(
        bookingId: bookingId,
        spaceId: '',
        spaceName: 'Booking Not Found',
        rating: 0,
        locationText: '--',
        tags: const [],
        dateText: '--',
        timeText: '--',
        notes: 'No details found for this booking.',
        totalPrice: 0,
        currency: '₪',
        imageAsset: AppAssets.home,
      );
    }

    final b = bookingDoc.data()!;
    final spaceId = b['space_id'] as String? ?? b['spaceId'] as String? ?? '';

    // جلب تفاصيل المساحة إن وجدت
    Map<String, dynamic> spaceData = {};
    if (spaceId.isNotEmpty) {
      final spaceDoc = await FirebaseFirestore.instance
          .collection('workspaces')
          .doc(spaceId)
          .get();
      spaceData = spaceDoc.data() ?? {};
    }

    final tags = (b['tags'] as List?)?.cast<String>() ??
        (spaceData['tags'] as List?)?.cast<String>() ??
        const ['Wi-Fi', 'Quiet'];

    final status = b['status'] as String? ?? 'upcoming';
    final notes = b['notes'] as String? ??
        switch (status) {
          'upcoming' =>
            'Please arrive 10 minutes early. Reception will guide you to the room.',
          'completed' => 'Thanks for visiting! You can rebook the same space anytime.',
          'cancelled' =>
            'This booking was cancelled. If you need help, contact support.',
          _ => 'No extra notes.',
        };

    return BookingDetails(
      bookingId: bookingId,
      spaceId: spaceId,
      spaceName: b['space_name'] as String? ?? spaceData['name'] as String? ?? 'Space',
      rating: (b['rating'] as num?)?.toDouble() ??
          (spaceData['rating'] as num?)?.toDouble() ??
          4.0,
      locationText: b['location_text'] as String? ??
          spaceData['locationAddress'] as String? ??
          spaceData['location_address'] as String? ??
          '--',
      tags: tags,
      dateText: b['date_text'] as String? ?? b['date'] as String? ?? '--',
      timeText: b['time_text'] as String? ?? b['time_slot'] as String? ?? '--',
      notes: notes,
      totalPrice: (b['total_price'] as num?)?.toDouble() ??
          (b['totalPrice'] as num?)?.toDouble() ??
          0.0,
      currency: b['currency'] as String? ?? '₪',
      imageAsset: AppAssets.home,
      imageUrl: b['image_url'] as String? ?? spaceData['image_url'] as String?,
    );
  }
}
