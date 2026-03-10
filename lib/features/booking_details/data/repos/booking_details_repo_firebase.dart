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
    final spaceId = b['spaceId'] as String? ?? b['space_id'] as String? ?? b['workspaceId'] as String? ?? '';

    // جلب تفاصيل المساحة إن وجدت
    Map<String, dynamic> spaceData = {};
    if (spaceId.isNotEmpty) {
      final spaceDoc = await FirebaseFirestore.instance
          .collection('workspaces')
          .doc(spaceId)
          .get();
      spaceData = spaceDoc.data() ?? {};
    }

    // استخراج الأمنيات من Firestore (قد تكون List<String> أو List<Map>)
    List<String> tags;
    final rawTags = b['amenities'] ?? b['tags'] ?? spaceData['amenities'] ?? spaceData['tags'];
    if (rawTags is List) {
      tags = rawTags.map((e) {
        if (e is String) return e;
        if (e is Map) return (e['name'] ?? e['label'] ?? '').toString();
        return '';
      }).where((s) => s.isNotEmpty).take(4).toList();
    } else {
      tags = const ['Wi-Fi', 'Quiet'];
    }

    // تحويل Timestamps إلى نصوص
    final startTs = b['startDate'] as Timestamp?;
    final endTs = b['endDate'] as Timestamp?;

    String dateText = b['date_text'] as String? ?? b['date'] as String? ?? '--';
    String timeText = b['time_text'] as String? ?? b['time_slot'] as String? ?? '--';

    if (startTs != null && dateText == '--') {
      final dt = startTs.toDate();
      dateText = '${dt.day}/${dt.month}/${dt.year}';
    }
    if (startTs != null && timeText == '--') {
      final st = startTs.toDate();
      final fmt = '${st.hour.toString().padLeft(2, '0')}:${st.minute.toString().padLeft(2, '0')}';
      if (endTs != null) {
        final et = endTs.toDate();
        timeText = '$fmt – ${et.hour.toString().padLeft(2, '0')}:${et.minute.toString().padLeft(2, '0')}';
      } else {
        timeText = fmt;
      }
    }

    final status = b['status'] as String? ?? 'upcoming';
    final notes = b['notes'] as String? ??
        switch (status) {
          'approved' || 'confirmed' =>
            'Please arrive 10 minutes early. Reception will guide you to the room.',
          'upcoming' =>
            'Please arrive 10 minutes early. Reception will guide you to the room.',
          'completed' => 'Thanks for visiting! You can rebook the same space anytime.',
          'cancelled' =>
            'This booking was cancelled. If you need help, contact support.',
          _ => 'No extra notes.',
        };

    // صورة المساحة
    final imageUrls = (b['images'] as List?)?.cast<String>() ??
        (spaceData['images'] as List?)?.cast<String>() ?? const [];
    final imageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    return BookingDetails(
      bookingId: bookingId,
      spaceId: spaceId,
      spaceName: b['spaceName'] as String? ??
          b['workspaceName'] as String? ??
          b['space_name'] as String? ??
          spaceData['name'] as String? ??
          'Space',
      rating: (b['rating'] as num?)?.toDouble() ??
          (spaceData['rating'] as num?)?.toDouble() ??
          (spaceData['stats']?['averageRating'] as num?)?.toDouble() ??
          4.0,
      locationText: b['location_text'] as String? ??
          spaceData['subtitle'] as String? ??
          spaceData['locationAddress'] as String? ??
          spaceData['location_address'] as String? ??
          '--',
      tags: tags,
      dateText: dateText,
      timeText: timeText,
      notes: notes,
      totalPrice: (b['totalAmount'] as num?)?.toDouble() ??
          (b['total_price'] as num?)?.toDouble() ??
          (b['totalPrice'] as num?)?.toDouble() ??
          0.0,
      currency: b['currency'] as String? ?? '₪',
      imageAsset: AppAssets.home,
      imageUrl: imageUrl ?? b['image_url'] as String?,
    );
  }
}
