import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../entities/payment_summary_entity.dart';

abstract class PaymentRepo {
  Future<List<PaymentMethodEntity>> getMethods();

  Future<PaymentSummaryEntity> getSummary({required String requestId});

  Future<PaymentReceiptEntity> pay({
    required String requestId,
    required PaymentMethodType method,
  });
}
