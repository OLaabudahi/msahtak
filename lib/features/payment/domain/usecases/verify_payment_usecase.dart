import '../repos/payment_repo.dart';

class VerifyPaymentUseCase {
  final PaymentRepo repo;

  const VerifyPaymentUseCase(this.repo);

  Future<bool> call(String bookingId) {
    return repo.verifyPayment(bookingId: bookingId);
  }
}
