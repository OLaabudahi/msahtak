import 'dart:typed_data';

import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../repos/payment_repo.dart';

class SubmitPaymentUseCase {
  final PaymentRepo repo;

  const SubmitPaymentUseCase(this.repo);

  Future<PaymentReceiptEntity> call({
    required String bookingId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    String? transferAccountHolder,
    String? transferTime,
    String? transferReference,
    Uint8List? receiptBytes,
    String? receiptFileName,
  }) {
    return repo.pay(
      bookingId: bookingId,
      method: method,
      methodName: methodName,
      receiptUrl: receiptUrl,
      cardNumber: cardNumber,
      cardExpiry: cardExpiry,
      cardCvv: cardCvv,
      cardHolder: cardHolder,
      transferAccountHolder: transferAccountHolder,
      transferTime: transferTime,
      transferReference: transferReference,
      receiptBytes: receiptBytes,
      receiptFileName: receiptFileName,
    );
  }
}
