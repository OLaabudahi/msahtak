import '../entities/payment_details_entity.dart';
import '../repos/payment_repo.dart';

class GetPaymentDetailsUseCase {
  final PaymentRepo repo;

  const GetPaymentDetailsUseCase(this.repo);

  Future<PaymentDetailsEntity> call(String bookingId) {
    return repo.getPaymentDetails(bookingId: bookingId);
  }
}
