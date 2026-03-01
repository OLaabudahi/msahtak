import 'package:equatable/equatable.dart';

class PaymentDetailsEntity extends Equatable {
  final String id;
  final String date;
  final String amount;
  final String status;
  final String method;
  final String reference;
  final String userName;
  final String bookingId;

  const PaymentDetailsEntity({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.reference,
    required this.userName,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [id, date, amount, status, method, reference, userName, bookingId];
}
