import '../entities/payment_method_entity.dart';
import '../entities/payment_receipt_entity.dart';
import '../repos/payment_repo.dart';

class PayBookingRequestUseCase {
  final PaymentRepo repo;

  const PayBookingRequestUseCase(this.repo);

  Future<PaymentReceiptEntity> call({
    required String requestId,
    required PaymentMethodType method,
  }) {
    return repo.pay(requestId: requestId, method: method);
  }
}
