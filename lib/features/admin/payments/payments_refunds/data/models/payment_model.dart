import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status.dart';

class PaymentModel {
  final String id;
  final String date;
  final String amount;
  final String status; 
  final String userName;
  final String bookingId;

  const PaymentModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.userName,
    required this.bookingId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: (json['id'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        amount: (json['amount'] ?? '').toString(),
        status: (json['status'] ?? 'paid').toString(),
        userName: (json['userName'] ?? '').toString(),
        bookingId: (json['bookingId'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'amount': amount,
        'status': status,
        'userName': userName,
        'bookingId': bookingId,
      };

  PaymentEntity toEntity() => PaymentEntity(
        id: id,
        date: date,
        amount: amount,
        status: _parse(status),
        userName: userName,
        bookingId: bookingId,
      );

  PaymentStatus _parse(String s) => switch (s) {
        'pending' => PaymentStatus.pending,
        'refunded' => PaymentStatus.refunded,
        _ => PaymentStatus.paid,
      };
}
