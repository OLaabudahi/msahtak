import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_receipt_entity.dart';

class PaymentReceiptModel extends PaymentReceiptEntity {
  const PaymentReceiptModel({
    required super.amountPaid,
    required super.currency,
    required super.method,
    required super.bookingId,
    required super.paidAt,
    required super.invoiceUrl,
  });

  factory PaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    return PaymentReceiptModel(
      amountPaid: (json['amountPaid'] as num).toInt(),
      currency: json['currency'] as String,
      method: PaymentMethodType.values.byName(json['method'] as String),
      bookingId: json['bookingId'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
      invoiceUrl: json['invoiceUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'amountPaid': amountPaid,
    'currency': currency,
    'method': method.name,
    'bookingId': bookingId,
    'paidAt': paidAt.toIso8601String(),
    'invoiceUrl': invoiceUrl,
  };
}
