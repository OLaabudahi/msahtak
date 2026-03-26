import 'dart:typed_data';

import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../repos/payment_repo.dart';

class PayBookingRequestUseCase {
  final PaymentRepo repo;

  const PayBookingRequestUseCase(this.repo);

  Future<PaymentReceiptEntity> call({
    required String requestId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    Uint8List? receiptBytes,
    String? receiptFileName,
  }) {
    return repo.pay(
      requestId: requestId,
      method: method,
      methodName: methodName,
      receiptUrl: receiptUrl,
      cardNumber: cardNumber,
      cardExpiry: cardExpiry,
      cardCvv: cardCvv,
      cardHolder: cardHolder,

    );
  }
}
