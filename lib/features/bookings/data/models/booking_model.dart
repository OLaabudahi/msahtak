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
    required super.rawStatus,
    required super.totalPrice,
    required super.currency,
    super.imageUrl,
    super.cancelledBy,
    super.startAt,
    super.endAt,
    super.cancelReason,
    super.cancellationStage,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    final startTs = map['startDate'] as Timestamp?;
    final endTs = map['endDate'] as Timestamp?;

    String dateText = '--';
    String timeText = '--';

    if (startTs != null) {
      final start = startTs.toDate();

      dateText = _dateWithDay(start);

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
      startAt: startTs?.toDate(),
      endAt: endTs?.toDate(),
      status: _normalizeStatus(map['status']),
      rawStatus: (map['status'] ?? '').toString().toLowerCase(),
      totalPrice:
      (map['totalAmount'] ?? map['totalPrice'] ?? 0)
          .toDouble(),
      currency: map['currency'] ?? '₪',
      imageUrl: map['imageUrl'],
      cancelledBy: _parseCancelledBy(map['cancelledBy']),
      cancelReason: (map['cancelReason'] ?? map['cancellationReason'] ?? '').toString(),
      cancellationStage: (map['cancellationStage'] ?? '').toString(),
    );
  }

  static String _dateWithDay(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]} ${date.day}/${date.month}/${date.year}';
  }

  static String _parseCancelledBy(dynamic value) {
    if (value is Map) {
      final name = (value['name'] ?? '').toString().trim();
      if (name.isNotEmpty) return name;
      final role = (value['role'] ?? '').toString().trim();
      if (role.isNotEmpty) return role;
      return '';
    }
    return (value ?? '').toString();
  }

  static String _fmt(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Image provider helper.
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageUrl ?? 'assets/images/home.png');
  }

  static String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
      case 'approved_waiting_payment':
        return 'awaiting_payment';
      case 'payment_under_review':
        return 'awaiting_confirmation';
      case 'paid':
      case 'active':
        return 'confirmed';
      case 'confirmed':
        return 'confirmed';
      case 'pending':
      case 'under_review':
        return 'upcoming';
      case 'cancelled':
      case 'canceled':
      case 'rejected':
      case 'expired':
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
      currency: map['currency'] ?? '₪',
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

/// Booking model (dummy now, API-ready structure).
class Booking extends Equatable {
  final String bookingId;
  final String spaceId;

  final String spaceName;
  final String dateText; // Example: "Mon, 12 Aug"
  final String timeText; // Example: "09:00 - 12:00"
  final String status; // upcoming / completed / cancelled
  final double totalPrice;
  final String currency;

  /// Image (asset for now, URL later).
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

  /// Image provider helper (API-ready).
  ImageProvider get imageProvider {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(imageAsset ?? 'assets/images/home.png');
  }

  /// Deserialize from JSON (API-ready).
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
