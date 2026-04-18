import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_receipt_entity.dart';

class UserReceiptModel extends UserReceiptEntity {
  const UserReceiptModel({
    required super.bookingId,
    required super.spaceName,
    required super.userName,
    required super.userEmail,
    required super.startDate,
    required super.endDate,
    required super.paymentMethod,
    required super.totalPrice,
    required super.currency,
    required super.status,
    required super.createdAt,
  });

  factory UserReceiptModel.fromMap(Map<String, dynamic> map) {
    final startDate = _parseDate(map['startDate']) ??
        _parseDate(map['startAt']) ??
        _parseDate(map['createdAt']) ??
        _parseDate(map['paidAt']) ??
        _parseDate(map['updatedAt']) ??
        DateTime.now();
    final endDate = _parseDate(map['endDate']) ?? _parseDate(map['endAt']) ?? startDate;
    final createdAt = _parseDate(map['paidAt']) ??
        _parseDate(map['createdAt']) ??
        _parseDate(map['updatedAt']) ??
        startDate;

    return UserReceiptModel(
      bookingId: (map['id'] ?? map['bookingId'] ?? '').toString(),
      spaceName: (map['spaceName'] ?? map['workspaceName'] ?? 'Space').toString(),
      userName: (map['userName'] ?? map['customerName'] ?? '').toString(),
      userEmail: (map['userEmail'] ?? map['customerEmail'] ?? '').toString(),
      startDate: startDate,
      endDate: endDate,
      paymentMethod: (map['paymentMethodName'] ?? map['paymentMethod'] ?? 'card').toString(),
      totalPrice: _parseAmount(map['totalAmount'] ?? map['totalPrice']),
      currency: (map['currency'] ?? '₪').toString(),
      status: (map['status'] ?? '').toString().toLowerCase(),
      createdAt: createdAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0;
    return 0;
  }
}
