import 'package:equatable/equatable.dart';

import 'payment_method_entity.dart';

class PaymentReceiptEntity extends Equatable {
  final int amountPaid;
  final String currency;
  final PaymentMethodType method;
  final String bookingId;
  final DateTime paidAt;

  
  final String? invoiceUrl;

  const PaymentReceiptEntity({
    required this.amountPaid,
    required this.currency,
    required this.method,
    required this.bookingId,
    required this.paidAt,
    required this.invoiceUrl,
  });

  @override
  List<Object?> get props => [
    amountPaid,
    currency,
    method,
    bookingId,
    paidAt,
    invoiceUrl,
  ];
}


