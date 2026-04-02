import 'dart:typed_data';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_receipt_entity.dart';
import '../../domain/entities/payment_summary_entity.dart';
import '../../domain/repos/payment_repo.dart';
import '../models/admin_payment_review_model.dart';
import '../models/payment_receipt_model.dart';
import '../models/payment_summary_model.dart';
import '../sources/payment_firebase_source.dart';


class PaymentRepoFirebase implements PaymentRepo {
  final PaymentFirebaseSource source;

  PaymentRepoFirebase({required this.source});

  @override
  Future<List<PaymentMethodEntity>> getMethods({
    required String requestId,
  }) async {
    final booking = await source.getBooking(requestId);
    if (booking == null) return [];

    final spaceId = (booking['spaceId'] ?? '') as String;
    if (spaceId.isEmpty) return [];

    final space = await source.getSpace(spaceId);
    if (space == null) return [];

    final rawMethods =
        (space['paymentMethods'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return rawMethods
        .where((m) => (m['id'] as String? ?? '').isNotEmpty)
        .map((m) {
      final id = m['id'] as String;
      final name = m['name'] as String? ?? id;
      final details = _buildDetails(m);

      return PaymentMethodEntity(
        type: id,
        title: name,
        details: details,
      );
    })
        .toList();
  }

  
  String _buildDetails(Map<String, dynamic> m) {
    final parts = <String>[];

    if ((m['iban'] as String?)?.isNotEmpty == true) {
      parts.add('IBAN: ${m['iban']}');
    }

    if ((m['accountName'] as String?)?.isNotEmpty == true) {
      parts.add('Name: ${m['accountName']}');
    }

    if ((m['phone'] as String?)?.isNotEmpty == true) {
      parts.add('Phone: ${m['phone']}');
    }

    return parts.join('\n');
  }

  @override
  Future<PaymentSummaryEntity> getSummary({
    required String requestId,
  }) async {
    final booking = await source.getBooking(requestId);
    if (booking == null) throw Exception('Booking not found');

    final status = booking['status'] as String? ?? '';

    if (status != 'approved_waiting_payment' &&
        status != 'approved' &&
        status != 'confirmed') {
      throw Exception('Payment not allowed');
    }

    final totalAmount = (booking['totalPrice'] as num?)?.toInt() ?? 0;
    final currency = booking['currency'] as String? ?? 'â‚ھ';
    final durationUnit = booking['durationUnit'] as String? ?? 'day';
    final durationValue = booking['durationValue'] as int? ?? 1;
    final spaceName = booking['spaceName'] as String? ?? 'Space';

    final items = <PaymentLineItemEntity>[];

    if (durationUnit == 'day') {
      items.add(PaymentLineItemEntity(
        label: 'Daily أ— $durationValue',
        amount: totalAmount,
      ));
    } else if (durationUnit == 'week') {
      items.add(PaymentLineItemEntity(
        label: 'Weekly أ— $durationValue',
        amount: totalAmount,
      ));
    } else if (durationUnit == 'month') {
      items.add(PaymentLineItemEntity(
        label: 'Monthly أ— $durationValue',
        amount: totalAmount,
      ));
    } else {
      items.add(PaymentLineItemEntity(
        label: spaceName,
        amount: totalAmount,
      ));
    }

    const serviceFee = 8;

    items.add(
      const PaymentLineItemEntity(
        label: 'Service Fee',
        amount: serviceFee,
      ),
    );

    final total = items.fold<int>(0, (sum, item) => sum + item.amount);

    return PaymentSummaryModel(
      items: items,
      total: total,
      currency: currency,
    );
  }

  @override
  Future<PaymentReceiptEntity> pay({
    required String requestId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    Uint8List? receiptBytes,
    String? receiptFileName,
  }) async {
    final booking = await source.getBooking(requestId);
    if (booking == null) throw Exception('Booking not found');

    final status = booking['status'] as String? ?? '';

    if (status == 'payment_under_review' ||
        status == 'confirmed' ||
        status == 'paid') {
      throw Exception('Already paid');
    }

    if (status != 'approved_waiting_payment' &&
        status != 'approved') {
      throw Exception('Not allowed to pay');
    }

    final totalAmount = (booking['totalPrice'] as num?)?.toInt() ?? 0;
    final currency = booking['currency'] as String? ?? 'â‚ھ';
    final userId = booking['userId'] as String? ?? '';
    final spaceName = booking['spaceName'] as String? ?? 'Space';
    final spaceId = booking['spaceId'] as String? ?? '';

    final paidAt = DateTime.now();

    
    String? receiptUrl;

    if (receiptBytes != null && receiptFileName != null) {
      receiptUrl = await source.uploadReceipt(
        requestId: requestId,
        bytes: receiptBytes,
        fileName: receiptFileName,
      );
    }

    final updateData = {
      'status': 'payment_under_review',
      'paymentMethod': method,
      'paymentMethodName': methodName,
      'paymentReceiptUrl': receiptUrl,
      'paidAt': paidAt.toIso8601String(),
    };

    if (cardNumber != null && cardNumber.isNotEmpty) {
      final clean = cardNumber.replaceAll(RegExp(r'\D'), '');

      updateData['cardLast4'] =
      clean.length >= 4 ? clean.substring(clean.length - 4) : clean;

      updateData['cardHolder'] = cardHolder ?? '';
      updateData['cardExpiry'] = cardExpiry ?? '';
    }

    
    await source.submitPayment(
      requestId: requestId,
      data: updateData,
    );

    
    if (userId.isNotEmpty) {
      await source.createAdminReview(
        review: AdminPaymentReviewModel(
          bookingId: requestId,
          userId: userId,
          spaceName: spaceName,
          amount: totalAmount,
          currency: currency,
          paymentMethod: methodName,
          receiptUrl: receiptUrl,
          paidAt: paidAt,
          status: 'pending',
          createdAt: DateTime.now(), spaceId: spaceId,
        ),
      );

    }

    return PaymentReceiptModel(
      amountPaid: totalAmount,
      currency: currency,
      method: method,
      bookingId: requestId,
      paidAt: paidAt,
      invoiceUrl: receiptUrl,
    );
  }
}
