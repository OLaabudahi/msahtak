import 'dart:typed_data';

import '../repos/payment_repo.dart';

class UploadPaymentReceiptUseCase {
  final PaymentRepo repo;

  const UploadPaymentReceiptUseCase(this.repo);

  Future<String?> call({
    required String bookingId,
    required Uint8List bytes,
    required String fileName,
  }) {
    return repo.uploadPaymentReceipt(
      bookingId: bookingId,
      bytes: bytes,
      fileName: fileName,
    );
  }
}
