import '../entities/user_receipt_entity.dart';
import '../repos/payments_receipts_repo.dart';

class GetUserReceiptsUseCase {
  final PaymentsReceiptsRepo repo;

  GetUserReceiptsUseCase(this.repo);

  Future<List<UserReceiptEntity>> call() {
    return repo.getUserReceipts();
  }
}
