import '../repos/payments_repo.dart';

class IssueRefundUseCase {
  final PaymentsRepo repo;
  const IssueRefundUseCase(this.repo);

  Future<void> call({required String paymentId}) => repo.issueRefund(paymentId: paymentId);
}
