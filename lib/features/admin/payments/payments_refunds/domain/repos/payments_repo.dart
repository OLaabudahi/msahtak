import '../entities/payment_entity.dart';
import '../entities/payment_details_entity.dart';
import '../entities/payment_status.dart';

abstract class PaymentsRepo {
  Future<List<PaymentEntity>> getPayments({required String periodId, required PaymentStatus status});
  Future<PaymentDetailsEntity> getPaymentDetails({required String paymentId});
  Future<void> issueRefund({required String paymentId});
}


