import 'package:flutter/cupertino.dart';

class BookingEntity {
  final String bookingId;
  final String spaceId;
  final String spaceName;

  final String dateText;
  final String timeText;

  final String status;

  final double totalPrice;
  final String currency;

  final String? imageUrl;

  BookingEntity({
    required this.bookingId,
    required this.spaceId,
    required this.spaceName,
    required this.dateText,
    required this.timeText,
    required this.status,
    required this.totalPrice,
    required this.currency,
    this.imageUrl,
  });
  /// âœ… imageProvider (API-ready)
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageUrl ?? 'assets/images/home.png');
  }
}

