import '../../domain/entities/payment_details_entity.dart';

class PaymentDetailsModel {
  final String id;
  final String date;
  final String amount;
  final String status;
  final String method;
  final String reference;
  final String userName;
  final String bookingId;

  const PaymentDetailsModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.reference,
    required this.userName,
    required this.bookingId,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) => PaymentDetailsModel(
        id: (json['id'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        amount: (json['amount'] ?? '').toString(),
        status: (json['status'] ?? '').toString(),
        method: (json['method'] ?? '').toString(),
        reference: (json['reference'] ?? '').toString(),
        userName: (json['userName'] ?? '').toString(),
        bookingId: (json['bookingId'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'amount': amount,
        'status': status,
        'method': method,
        'reference': reference,
        'userName': userName,
        'bookingId': bookingId,
      };

  PaymentDetailsEntity toEntity() => PaymentDetailsEntity(
        id: id,
        date: date,
        amount: amount,
        status: status,
        method: method,
        reference: reference,
        userName: userName,
        bookingId: bookingId,
      );
}
