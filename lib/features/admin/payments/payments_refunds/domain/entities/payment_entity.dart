import 'package:equatable/equatable.dart';
import 'payment_status.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String date;
  final String amount;
  final PaymentStatus status;
  final String userName;
  final String bookingId;

  const PaymentEntity({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.userName,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [id, date, amount, status, userName, bookingId];
}


