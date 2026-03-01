import '../entities/payment_entity.dart';
import '../entities/payment_status.dart';
import '../repos/payments_repo.dart';

class GetPaymentsUseCase {
  final PaymentsRepo repo;
  const GetPaymentsUseCase(this.repo);

  Future<List<PaymentEntity>> call({required String periodId, required PaymentStatus status}) {
    return repo.getPayments(periodId: periodId, status: status);
  }
}
