import '../../../../constants/app_assets.dart';
import '../../domain/repos/booking_details_repo.dart';
import '../models/booking_details_model.dart';
import '../sources/booking_details_source.dart';

class BookingDetailsRepoFirebase implements BookingDetailsRepo {
  final BookingDetailsSource source;

  BookingDetailsRepoFirebase({required this.source});

  @override
  Future<BookingDetails> fetchBookingDetails(String bookingId) async {
    final bookingData = await source.getBookingById(bookingId);

    if (bookingData == null) {
      return BookingDetails(
        bookingId: bookingId,
        spaceId: '',
        spaceName: 'Space',
        rating: 0,
        locationText: '--',
        tags: const [],
        dateText: '--',
        timeText: '--',
        notes: '',
        totalPrice: 0,
        currency: '₪',
        imageAsset: AppAssets.home,
      );
    }

    final spaceId =
        (bookingData['spaceId'] ?? bookingData['space_id'] ?? bookingData['workspaceId'] ?? '')
            .toString();
    final spaceData = await source.getSpaceById(spaceId) ?? const <String, dynamic>{};

    final rawTags =
        bookingData['amenities'] ?? bookingData['tags'] ?? spaceData['amenities'] ?? spaceData['tags'];
    final tags = (rawTags is List)
        ? rawTags
            .map(
              (e) => e is String
                  ? e
                  : (e is Map ? (e['name'] ?? e['label'] ?? '').toString() : ''),
            )
            .where((e) => e.isNotEmpty)
            .take(4)
            .toList(growable: false)
        : const ['Wi-Fi', 'Quiet'];

    final dateText = (bookingData['date_text'] ?? bookingData['date'] ?? '--').toString();
    final timeText = (bookingData['time_text'] ?? bookingData['time_slot'] ?? '--').toString();
    final status = (bookingData['status'] ?? 'upcoming').toString();

    final imageUrls = (bookingData['images'] as List?)?.cast<String>() ??
        (spaceData['images'] as List?)?.cast<String>() ??
        const <String>[];

    return BookingDetails(
      bookingId: bookingId,
      spaceId: spaceId,
      spaceName: (bookingData['spaceName'] ??
              bookingData['workspaceName'] ??
              bookingData['space_name'] ??
              spaceData['name'] ??
              'Space')
          .toString(),
      rating: (bookingData['rating'] as num?)?.toDouble() ??
          (spaceData['rating'] as num?)?.toDouble() ??
          4.0,
      locationText: (bookingData['location_text'] ??
              spaceData['subtitle'] ??
              spaceData['locationAddress'] ??
              '--')
          .toString(),
      tags: tags,
      dateText: dateText,
      timeText: timeText,
      notes: (bookingData['notes'] ?? _defaultNote(status)).toString(),
      totalPrice: (bookingData['totalAmount'] as num?)?.toDouble() ??
          (bookingData['total_price'] as num?)?.toDouble() ??
          (bookingData['totalPrice'] as num?)?.toDouble() ??
          0,
      currency: (bookingData['currency'] ?? '₪').toString(),
      imageAsset: AppAssets.home,
      imageUrl: imageUrls.isNotEmpty
          ? imageUrls.first
          : (bookingData['image_url'] ?? bookingData['imageUrl']) as String?,
    );
  }

  @override
  Future<void> cancelBooking(String bookingId) {
    return source.cancelBooking(bookingId);
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) {
    return source.updateBookingStatus(bookingId: bookingId, status: status);
  }

  String _defaultNote(String status) {
    switch (status) {
      case 'approved':
      case 'confirmed':
      case 'upcoming':
      case 'completed':
      case 'cancelled':
      default:
        return '';
    }
  }
}
