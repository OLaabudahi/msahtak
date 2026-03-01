import '../entities/payment_details_entity.dart';
import '../repos/payments_repo.dart';

class GetPaymentDetailsUseCase {
  final PaymentsRepo repo;
  const GetPaymentDetailsUseCase(this.repo);

  Future<PaymentDetailsEntity> call({required String paymentId}) => repo.getPaymentDetails(paymentId: paymentId);
}
