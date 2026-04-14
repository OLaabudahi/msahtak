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
        _parseDate(map['createdAt']) ??
        _parseDate(map['updatedAt']) ??
        DateTime.now();
    final endDate = _parseDate(map['endDate']) ?? startDate;
    final createdAt = _parseDate(map['createdAt']) ?? startDate;

    return UserReceiptModel(
      bookingId: (map['id'] ?? '').toString(),
      spaceName: (map['spaceName'] ?? map['workspaceName'] ?? 'Space').toString(),
      userName: (map['userName'] ?? map['customerName'] ?? '').toString(),
      userEmail: (map['userEmail'] ?? map['customerEmail'] ?? '').toString(),
      startDate: startDate,
      endDate: endDate,
      paymentMethod: (map['paymentMethod'] ?? 'card').toString(),
      totalPrice: ((map['totalAmount'] ?? map['totalPrice'] ?? 0) as num).toDouble(),
      currency: (map['currency'] ?? '₪').toString(),
      status: (map['status'] ?? '').toString().toLowerCase(),
      createdAt: createdAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
