import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_request_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_receipt_entity.dart';
import '../../domain/entities/payment_summary_entity.dart';
import '../../domain/repos/payment_repo.dart';
import '../models/payment_receipt_model.dart';
import '../models/payment_summary_model.dart';

/// ✅ تنفيذ Firebase لـ PaymentRepo
class PaymentRepoFirebase implements PaymentRepo {
  final _db = FirebaseFirestore.instance;
  final Random _random;

  PaymentRepoFirebase({Random? random}) : _random = random ?? Random();

  @override
  Future<List<PaymentMethodEntity>> getMethods() async {
    return const [
      PaymentMethodEntity(type: PaymentMethodType.card, title: 'Credit / Debit Card'),
      PaymentMethodEntity(type: PaymentMethodType.palPay, title: 'Pal Pay'),
      PaymentMethodEntity(type: PaymentMethodType.jawwalPay, title: 'Jawwal Pay'),
      PaymentMethodEntity(type: PaymentMethodType.bankOfPalestine, title: 'Bank of Palestine'),
    ];
  }

  @override
  Future<PaymentSummaryEntity> getSummary({required String requestId}) async {
    final doc = await _db.collection('bookings').doc(requestId).get();
    if (!doc.exists) throw StateError('Booking not found');
    final d = doc.data()!;
    final status = d['status'] as String? ?? '';
    if (status != 'approved_waiting_payment' && status != 'approved' && status != 'confirmed') {
      throw StateError('Payment is available only after approval');
    }

    final totalAmount = (d['totalAmount'] as num?)?.toInt() ?? 0;
    final currency = d['currency'] as String? ?? '₪';
    final durationUnit = d['durationUnit'] as String? ?? 'days';
    final durationValue = d['durationValue'] as int? ?? 1;
    final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';

    final items = <PaymentLineItemEntity>[];
    if (durationUnit == 'days') {
      items.add(PaymentLineItemEntity(label: 'Daily × $durationValue', amount: totalAmount));
    } else if (durationUnit == 'weeks') {
      items.add(PaymentLineItemEntity(label: 'Weekly × $durationValue', amount: totalAmount));
    } else if (durationUnit == 'months') {
      items.add(PaymentLineItemEntity(label: 'Monthly × $durationValue', amount: totalAmount));
    } else {
      items.add(PaymentLineItemEntity(label: spaceName, amount: totalAmount));
    }

    const serviceFee = 8;
    items.add(const PaymentLineItemEntity(label: 'Service Fee', amount: serviceFee));
    final total = items.fold<int>(0, (s, e) => s + e.amount);

    return PaymentSummaryModel(items: items, total: total, currency: currency);
  }

  @override
  Future<PaymentReceiptEntity> pay({
    required String requestId,
    required PaymentMethodType method,
  }) async {
    final doc = await _db.collection('bookings').doc(requestId).get();
    if (!doc.exists) throw StateError('Booking not found');
    final d = doc.data()!;
    final status = d['status'] as String? ?? '';
    if (status == 'payment_under_review' || status == 'confirmed' || status == 'paid') {
      throw StateError('Payment already submitted');
    }
    if (status != 'approved_waiting_payment' && status != 'approved') {
      throw StateError('Cannot pay before approval');
    }

    final totalAmount = (d['totalAmount'] as num?)?.toInt() ?? 0;
    final currency = d['currency'] as String? ?? '₪';
    final uid = d['userId'] as String? ?? '';
    final spaceName = d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space';
    final paidAt = DateTime.now();

    // تحديث الحالة إلى payment_under_review
    await _db.collection('bookings').doc(requestId).update({
      'status': 'payment_under_review',
      'paymentMethod': method.name,
      'paidAt': Timestamp.fromDate(paidAt),
    });

    // إشعار للأدمن بوصول فاتورة جديدة
    if (uid.isNotEmpty) {
      await _db.collection('admin_payment_reviews').add({
        'bookingId': requestId,
        'userId': uid,
        'spaceName': spaceName,
        'amount': totalAmount,
        'currency': currency,
        'paymentMethod': method.name,
        'paidAt': Timestamp.fromDate(paidAt),
        'status': 'pending_review',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return PaymentReceiptModel(
      amountPaid: totalAmount,
      currency: currency,
      method: method,
      bookingId: requestId,
      paidAt: paidAt,
      invoiceUrl: null,
    );
  }
}
