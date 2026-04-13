import 'dart:typed_data';

import '../entities/payment_details_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../entities/payment_summary_entity.dart';

abstract class PaymentRepo {
  Future<List<PaymentMethodEntity>> getMethods({required String bookingId});

  Future<PaymentSummaryEntity> getSummary({required String bookingId});

  Future<PaymentDetailsEntity> getPaymentDetails({required String bookingId});

  Future<String?> uploadPaymentReceipt({
    required String bookingId,
    required Uint8List bytes,
    required String fileName,
  });

  Future<bool> verifyPayment({required String bookingId});

  Future<PaymentReceiptEntity> pay({
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
  });
}
