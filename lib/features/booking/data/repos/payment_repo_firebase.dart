import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<List<PaymentMethodEntity>> getMethods({required String requestId}) async {
    // جلب بيانات الحجز للحصول على معرّف المساحة
    final bookingDoc = await _db.collection('bookings').doc(requestId).get();
    if (!bookingDoc.exists) return [];

    final d = bookingDoc.data()!;
    final workspaceId = (d['workspaceId'] ?? d['spaceId'] ?? d['space_id'] ?? '') as String;
    if (workspaceId.isEmpty) return [];

    // جلب طرق الدفع من المساحة
    final wsDoc = await _db.collection('workspaces').doc(workspaceId).get();
    if (!wsDoc.exists) return [];

    final rawMethods = (wsDoc.data()?['paymentMethods'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return rawMethods
        .where((m) => (m['id'] as String? ?? '').isNotEmpty)
        .map((m) {
          final id = m['id'] as String;
          final name = m['name'] as String? ?? id;
          final details = _buildDetails(m);
          return PaymentMethodEntity(type: id, title: name, details: details);
        })
        .toList();
  }

  /// بناء نص التفاصيل من الحقول المنظّمة
  String _buildDetails(Map<String, dynamic> m) {
    final parts = <String>[];
    if ((m['iban'] as String?)?.isNotEmpty == true) parts.add('IBAN: ${m['iban']}');
    if ((m['accountName'] as String?)?.isNotEmpty == true) parts.add('Name: ${m['accountName']}');
    if ((m['phone'] as String?)?.isNotEmpty == true) parts.add('Phone: ${m['phone']}');
    return parts.join('\n');
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
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
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

    // بناء بيانات التحديث — تشمل تفاصيل البطاقة إن وُجدت
    final updateData = <String, dynamic>{
      'status': 'payment_under_review',
      'paymentMethod': method,
      'paymentMethodName': methodName,
      'paymentReceiptUrl': receiptUrl,
      'paidAt': Timestamp.fromDate(paidAt),
    };
    if (cardNumber != null && cardNumber.isNotEmpty) {
      // نحفظ آخر 4 أرقام فقط لأسباب أمنية
      final last4 = cardNumber.replaceAll(' ', '').replaceAll('-', '');
      updateData['cardLast4'] = last4.length >= 4 ? last4.substring(last4.length - 4) : last4;
      updateData['cardHolder'] = cardHolder ?? '';
      updateData['cardExpiry'] = cardExpiry ?? '';
    }

    // تحديث الحالة مع إشعار الدفع
    await _db.collection('bookings').doc(requestId).update(updateData);

    // إشعار للأدمن
    if (uid.isNotEmpty) {
      await _db.collection('admin_payment_reviews').add({
        'bookingId': requestId,
        'userId': uid,
        'spaceName': spaceName,
        'amount': totalAmount,
        'currency': currency,
        'paymentMethod': methodName,
        'paymentReceiptUrl': receiptUrl,
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
      invoiceUrl: receiptUrl,
    );
  }
}
