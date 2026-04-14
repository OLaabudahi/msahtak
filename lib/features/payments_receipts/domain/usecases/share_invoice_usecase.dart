import '../entities/user_receipt_entity.dart';
import '../repos/payments_receipts_repo.dart';

class ShareInvoiceUseCase {
  final PaymentsReceiptsRepo repo;

  ShareInvoiceUseCase(this.repo);

  Future<void> call(UserReceiptEntity invoice) {
    return repo.shareInvoice(invoice);
  }
}
