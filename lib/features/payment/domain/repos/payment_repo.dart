import 'dart:typed_data';

import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../entities/payment_summary_entity.dart';

abstract class PaymentRepo {
  
  Future<List<PaymentMethodEntity>> getMethods({required String requestId});

  Future<PaymentSummaryEntity> getSummary({required String requestId});

  
  Future<PaymentReceiptEntity> pay({
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
  });
}
