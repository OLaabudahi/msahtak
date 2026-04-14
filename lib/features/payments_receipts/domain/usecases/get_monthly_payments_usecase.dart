import '../repos/payments_receipts_repo.dart';

class GetMonthlyPaymentsUseCase {
  final PaymentsReceiptsRepo repo;

  GetMonthlyPaymentsUseCase(this.repo);

  Future<Map<int, double>> call({
    required int year,
    required int month,
  }) {
    return repo.getMonthlyPayments(year: year, month: month);
  }
}
