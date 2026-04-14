import 'dart:typed_data';

import '../entities/user_receipt_entity.dart';
import '../repos/payments_receipts_repo.dart';

class GenerateInvoicePdfUseCase {
  final PaymentsReceiptsRepo repo;

  GenerateInvoicePdfUseCase(this.repo);

  Future<Uint8List> call(UserReceiptEntity invoice) {
    return repo.generateInvoicePdf(invoice);
  }
}
