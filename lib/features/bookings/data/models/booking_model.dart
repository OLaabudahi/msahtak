import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';
import 'package:flutter/material.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.spaceId,
    required super.spaceName,
    required super.dateText,
    required super.timeText,
    required super.status,
    required super.totalPrice,
    required super.currency,
    super.imageUrl,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    final startTs = map['startDate'] as Timestamp?;
    final endTs = map['endDate'] as Timestamp?;

    String dateText = '--';
    String timeText = '--';

    if (startTs != null) {
      final start = startTs.toDate();

      dateText = '${start.day}/${start.month}/${start.year}';

      if (endTs != null) {
        final end = endTs.toDate();
        timeText = '${_fmt(start)} - ${_fmt(end)}';
      } else {
        timeText = _fmt(start);
      }
    }

    return BookingModel(
      bookingId: map['id'] ?? '',
      spaceId: map['spaceId'] ?? map['space_id'] ?? '',
      spaceName:
      map['spaceName'] ?? map['workspaceName'] ?? 'Space',
      dateText: dateText,
      timeText: timeText,
      status: _normalizeStatus(map['status']),
      totalPrice:
      (map['totalAmount'] ?? map['totalPrice'] ?? 0)
          .toDouble(),
      currency: map['currency'] ?? 'â‚ھ',
      imageUrl: map['imageUrl'],
    );
  }

  static String _fmt(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// âœ… imageProvider
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageUrl ?? 'assets/images/home.png');
  }

  static String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return 'confirmed';
      case 'pending':
      case 'under_review':
        return 'upcoming';
      case 'cancelled':
      case 'rejected':
        return 'cancelled';
      case 'completed':
        return 'completed';
      default:
        return 'upcoming';
    }
  }
}
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.spaceId,
    required super.spaceName,
    required super.dateText,
    required super.timeText,
    required super.status,
    required super.totalPrice,
    required super.currency,
    super.imageUrl,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    final startTs = map['startDate'] as Timestamp?;
    final endTs = map['endDate'] as Timestamp?;

    String dateText = '--';
    String timeText = '--';

    if (startTs != null) {
      final start = startTs.toDate();

      dateText = '${start.day}/${start.month}/${start.year}';

      if (endTs != null) {
        final end = endTs.toDate();
        timeText =
        '${_fmt(start)} - ${_fmt(end)}';
      } else {
        timeText = _fmt(start);
      }
    }

    return BookingModel(
      bookingId: map['id'] ?? '',
      spaceId: map['spaceId'] ?? map['space_id'] ?? '',
      spaceName:
      map['spaceName'] ?? map['workspaceName'] ?? 'Space',
      dateText: dateText,
      timeText: timeText,
      status: _normalizeStatus(map['status']),
      totalPrice:
      (map['totalAmount'] ?? map['totalPrice'] ?? 0)
          .toDouble(),
      currency: map['currency'] ?? 'â‚ھ',
      imageUrl: map['imageUrl'],
    );
  }

  static String _fmt(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return 'confirmed';
      case 'pending':
      case 'under_review':
        return 'upcoming';
      case 'cancelled':
      case 'rejected':
        return 'cancelled';
      case 'completed':
        return 'completed';
      default:
        return 'upcoming';
    }
  }
}
*/


/*
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// âœ… ظ…ظˆط¯ظٹظ„ ط§ظ„ط­ط¬ط² (Dummy ط§ظ„ط¢ظ† - ط¬ط§ظ‡ط² ظ„ظ„ظ€ API)
class Booking extends Equatable {
  final String bookingId;
  final String spaceId;

  final String spaceName;
  final String dateText; // ظ…ط«ط§ظ„: "Mon, 12 Aug"
  final String timeText; // ظ…ط«ط§ظ„: "09:00 - 12:00"
  final String status; // upcoming / completed / cancelled
  final double totalPrice;
  final String currency;

  /// طµظˆط±ط© (asset ط§ظ„ط¢ظ† - url ظ„ط§ط­ظ‚ط§ظ‹)
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

  /// âœ… imageProvider (API-ready)
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageAsset ?? 'assets/images/home.png');
  }

  /// âœ… (API READY - ظƒظˆظ…ظ†طھ) ظ…ظ† JSON
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
*/


