import '../../domain/entities/user_receipt_entity.dart';
import '../../domain/repos/payments_receipts_repo.dart';
import '../models/user_receipt_model.dart';
import '../sources/payments_receipts_firebase_source.dart';
import 'dart:io';
import 'dart:typed_data';

class PaymentsReceiptsRepoFirebase implements PaymentsReceiptsRepo {
  final PaymentsReceiptsFirebaseSource source;

  PaymentsReceiptsRepoFirebase(this.source);

  static const _excludedStatuses = {'cancelled', 'canceled'};

  @override
  Future<List<UserReceiptEntity>> getUserReceipts() async {
    final rows = await source.fetchUserBookingsForReceipts();

    final receipts = rows
        .where((row) => !_excludedStatuses.contains((row['status'] ?? '').toString().toLowerCase()))
        .map((row) {
          final withFallbackUser = Map<String, dynamic>.from(row);
          if ((withFallbackUser['userName'] ?? '').toString().trim().isEmpty) {
            withFallbackUser['userName'] = source.currentUserName;
          }
          if ((withFallbackUser['userEmail'] ?? '').toString().trim().isEmpty) {
            withFallbackUser['userEmail'] = source.currentUserEmail;
          }
          return UserReceiptModel.fromMap(withFallbackUser);
        })
        .toList(growable: false)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return receipts;
  }

  @override
  Future<Map<int, double>> getMonthlyPayments({
    required int year,
    required int month,
  }) async {
    final receipts = await getUserReceipts();
    final inMonth = receipts.where((r) => r.startDate.year == year && r.startDate.month == month);

    final byDay = <int, double>{};
    for (final receipt in inMonth) {
      byDay.update(receipt.startDate.day, (value) => value + receipt.totalPrice,
          ifAbsent: () => receipt.totalPrice);
    }

    return byDay;
  }

  @override
  Future<Uint8List> generateInvoicePdf(UserReceiptEntity invoice) {
    return source.generateInvoicePdf(
      bookingId: invoice.bookingId,
      spaceName: invoice.spaceName,
      userName: invoice.userName,
      userEmail: invoice.userEmail,
      startDate: invoice.startDate,
      endDate: invoice.endDate,
      paymentMethod: invoice.paymentMethod,
      totalPrice: invoice.totalPrice,
      currency: invoice.currency,
      status: invoice.status,
      createdAt: invoice.createdAt,
    );
  }

  @override
  Future<File> downloadInvoice(UserReceiptEntity invoice) async {
    final bytes = await generateInvoicePdf(invoice);
    return source.saveInvoicePdf(
      bytes: bytes,
      bookingId: invoice.bookingId,
    );
  }

  @override
  Future<void> shareInvoice(UserReceiptEntity invoice) async {
    final file = await downloadInvoice(invoice);
    await source.shareInvoiceFile(file);
  }
}
