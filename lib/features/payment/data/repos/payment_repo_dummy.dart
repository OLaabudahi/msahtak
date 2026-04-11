import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import '../../../booking_request/data/sources/booking_in_memory_store.dart';
import '../../../booking_request/domain/entities/booking_request_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_receipt_entity.dart';
import '../../domain/entities/payment_summary_entity.dart';
import '../../domain/repos/payment_repo.dart';
import '../models/payment_receipt_model.dart';
import '../models/payment_summary_model.dart';

class PaymentRepoDummy implements PaymentRepo {
  final BookingInMemoryStore _store;
  final Random _random;

  PaymentRepoDummy({BookingInMemoryStore? store, Random? random})
    : _store = store ?? BookingInMemoryStore.instance,
      _random = random ?? Random();

  @override
  Future<List<PaymentMethodEntity>> getMethods({required String bookingId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const <PaymentMethodEntity>[
      PaymentMethodEntity(type: 'bank_of_palestine', title: 'Bank of Palestine', details: 'IBAN: PS00XXXX\nAccount: 123456'),
      PaymentMethodEntity(type: 'jawwal_pay', title: 'Jawwal Pay', details: 'Phone: 059-XXXXXXX'),
    ];
  }

  @override
  Future<PaymentSummaryEntity> getSummary({required String bookingId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final req = _store.get(bookingId);
    if (req == null) throw StateError('Request not found');
    if (!req.isApproved) throw StateError('Payment is available only after approval');

    final items = <PaymentLineItemEntity>[
      PaymentLineItemEntity(label: 'Daily', amount: (req.totalAmount * 0.55).round()),
      PaymentLineItemEntity(label: 'Weekly', amount: (req.totalAmount * 0.35).round()),
      PaymentLineItemEntity(label: 'Monthly', amount: (req.totalAmount * 0.10).round()),
      const PaymentLineItemEntity(label: 'Service Fee', amount: 8),
    ];
    final total = items.fold<int>(0, (s, e) => s + e.amount);
    return PaymentSummaryModel(items: items, total: total, currency: req.currency);
  }

  @override
  Future<PaymentReceiptEntity> pay({
    required String bookingId,
    required PaymentMethodType method,
    required String methodName,
    String? receiptUrl,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
    String? transferAccountHolder,
    String? transferTime,
    String? transferReference,
    Uint8List? receiptBytes,
    String? receiptFileName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final req = _store.get(bookingId);
    if (req == null) throw StateError('Request not found');
    if (!req.isApproved) throw StateError('Cannot pay before approval');
    if (req.status == BookingRequestStatus.paid) throw StateError('Already paid');

    final receipt = PaymentReceiptModel(
      amountPaid: req.totalAmount,
      currency: req.currency,
      method: method,
      bookingId: bookingId,
      paidAt: DateTime.now(),
      invoiceUrl: receiptUrl,
    );

    final updated = BookingRequestEntity(
      bookingId: req.bookingId,
      space: req.space,
      startDate: req.startDate,
      durationUnit: req.durationUnit,
      durationValue: req.durationValue,
      purposeId: req.purposeId,
      purposeLabel: req.purposeLabel,
      offerId: req.offerId,
      offerLabel: req.offerLabel,
      addOns: req.addOns,
      status: BookingRequestStatus.paid,
      statusHint: 'Payment successful',
      totalAmount: req.totalAmount,
      currency: req.currency,

    );
    _store.put(updated);
    return receipt;
  }

  String _generateId({required String prefix}) {
    final n = 1000 + _random.nextInt(9000);
    return '$prefix-$n';
  }
}

