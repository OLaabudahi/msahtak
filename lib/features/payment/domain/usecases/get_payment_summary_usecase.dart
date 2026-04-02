import '../entities/payment_summary_entity.dart';
import '../repos/payment_repo.dart';

class GetPaymentSummaryUseCase {
  final PaymentRepo repo;

  const GetPaymentSummaryUseCase(this.repo);

  Future<PaymentSummaryEntity> call(String bookingId) {
    return repo.getSummary(bookingId: bookingId);
  }
}


