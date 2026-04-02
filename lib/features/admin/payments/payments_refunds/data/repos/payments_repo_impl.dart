import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_details_entity.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/repos/payments_repo.dart';
import '../sources/payments_source.dart';

class PaymentsRepoImpl implements PaymentsRepo {
  final PaymentsSource source;
  const PaymentsRepoImpl(this.source);

  @override
  Future<List<PaymentEntity>> getPayments({required String periodId, required PaymentStatus status}) async {
    final s = switch (status) {
      PaymentStatus.pending => 'pending',
      PaymentStatus.refunded => 'refunded',
      _ => 'paid',
    };
    return (await source.fetchPayments(periodId: periodId, status: s)).map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<PaymentDetailsEntity> getPaymentDetails({required String paymentId}) async {
    final m = await source.fetchPaymentDetails(paymentId: paymentId);
    return m.toEntity();
  }

  @override
  Future<void> issueRefund({required String paymentId}) => source.issueRefund(paymentId: paymentId);
}


