import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// ✅ موديل الحجز (Dummy الآن - جاهز للـ API)
class Booking extends Equatable {
  final String bookingId;
  final String spaceId;

  final String spaceName;
  final String dateText; // مثال: "Mon, 12 Aug"
  final String timeText; // مثال: "09:00 - 12:00"
  final String status; // upcoming / completed / cancelled
  final double totalPrice;
  final String currency;

  /// صورة (asset الآن - url لاحقاً)
  final String? imageAsset;
  final String? imageUrl;

  const Booking({
    required this.bookingId,
    required this.spaceId,
    required this.spaceName,
    required this.dateText,
    required this.timeText,
    required this.status,
    required this.totalPrice,
    required this.currency,
    this.imageAsset,
    this.imageUrl,
  });

  /// ✅ imageProvider (API-ready)
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageAsset ?? 'assets/images/placeholder.png');
  }

  /// ✅ (API READY - كومنت) من JSON
  // factory Booking.fromJson(Map<String, dynamic> json) {
  //   return Booking(
  //     bookingId: json['bookingId'].toString(),
  //     spaceId: json['spaceId'].toString(),
  //     spaceName: json['spaceName'] ?? '',
  //     dateText: json['dateText'] ?? '',
  //     timeText: json['timeText'] ?? '',
  //     status: json['status'] ?? 'upcoming',
  //     totalPrice: (json['totalPrice'] ?? 0).toDouble(),
  //     currency: json['currency'] ?? 'USD',
  //     imageUrl: json['imageUrl'],
  //   );
  // }

  @override
  List<Object?> get props => [
    bookingId,
    spaceId,
    spaceName,
    dateText,
    timeText,
    status,
    totalPrice,
    currency,
    imageAsset,
    imageUrl,
  ];
}
