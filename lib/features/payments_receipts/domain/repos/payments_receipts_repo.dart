import '../entities/user_receipt_entity.dart';
import 'dart:io';
import 'dart:typed_data';

abstract class PaymentsReceiptsRepo {
  Future<List<UserReceiptEntity>> getUserReceipts();

  Future<Map<int, double>> getMonthlyPayments({
    required int year,
    required int month,
  });

  Future<Uint8List> generateInvoicePdf(UserReceiptEntity invoice);

  Future<File> downloadInvoice(UserReceiptEntity invoice);

  Future<void> shareInvoice(UserReceiptEntity invoice);
}
