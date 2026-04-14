import 'dart:io';

import '../entities/user_receipt_entity.dart';
import '../repos/payments_receipts_repo.dart';

class DownloadInvoiceUseCase {
  final PaymentsReceiptsRepo repo;

  DownloadInvoiceUseCase(this.repo);

  Future<File> call(UserReceiptEntity invoice) {
    return repo.downloadInvoice(invoice);
  }
}
