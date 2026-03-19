import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../entities/payment_summary_entity.dart';

abstract class PaymentRepo {
  /// جلب طرق الدفع من مساحة الحجز
  Future<List<PaymentMethodEntity>> getMethods({required String requestId});

  Future<PaymentSummaryEntity> getSummary({required String requestId});

  /// تأكيد الدفع مع رفع إشعار الدفع أو تفاصيل البطاقة
  Future<PaymentReceiptEntity> pay({
    required String requestId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
  });
}
