import 'dart:async';
import 'dart:math';

import '../../domain/entities/booking_request_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_receipt_entity.dart';
import '../../domain/entities/payment_summary_entity.dart';
import '../../domain/repos/payment_repo.dart';
import '../models/payment_receipt_model.dart';
import '../models/payment_summary_model.dart';
import '_booking_in_memory_store.dart';

class PaymentRepoDummy implements PaymentRepo {
  final BookingInMemoryStore _store;
  final Random _random;

  PaymentRepoDummy({BookingInMemoryStore? store, Random? random})
    : _store = store ?? BookingInMemoryStore.instance,
      _random = random ?? Random();

  @override
  Future<List<PaymentMethodEntity>> getMethods() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const <PaymentMethodEntity>[
      PaymentMethodEntity(
        type: PaymentMethodType.card,
        title: 'Credit / Debit Card',
      ),
      PaymentMethodEntity(type: PaymentMethodType.palPay, title: 'Pal Pay'),
      PaymentMethodEntity(
        type: PaymentMethodType.jawwalPay,
        title: 'Jawwal Pay',
      ),
      PaymentMethodEntity(
        type: PaymentMethodType.bankOfPalestine,
        title: 'Bank of Palestine',
      ),
    ];

    // API-ready example:
    // final res = await dio.get('/payments/methods');
    // return (res.data as List).map((e) => PaymentMethodModel.fromJson(e)).toList();
  }

  @override
  Future<PaymentSummaryEntity> getSummary({required String requestId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final req = _store.get(requestId);
    if (req == null) throw StateError('Request not found');
    if (!req.isApproved)
      throw StateError('Payment is available only after approval');

    // Dummy breakdown to match UI (daily/weekly/monthly can be dynamic later)
    final items = <PaymentLineItemEntity>[
      PaymentLineItemEntity(
        label: 'Daily',
        amount: (req.totalAmount * 0.55).round(),
      ),
      PaymentLineItemEntity(
        label: 'Weekly',
        amount: (req.totalAmount * 0.35).round(),
      ),
      PaymentLineItemEntity(
        label: 'Monthly',
        amount: (req.totalAmount * 0.10).round(),
      ),
      const PaymentLineItemEntity(label: 'Service Fee', amount: 8),
    ];
    final total = items.fold<int>(0, (s, e) => s + e.amount);

    return PaymentSummaryModel(
      items: items,
      total: total,
      currency: req.currency,
    );

    // API-ready example:
    // final res = await dio.get('/payments/summary?requestId=$requestId');
    // return PaymentSummaryModel.fromJson(res.data);
  }

  @override
  Future<PaymentReceiptEntity> pay({
    required String requestId,
    required PaymentMethodType method,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final req = _store.get(requestId);
    if (req == null) throw StateError('Request not found');
    if (!req.isApproved) throw StateError('Cannot pay before approval');
    if (req.status == BookingRequestStatus.paid)
      throw StateError('Already paid');

    final bookingId = req.bookingId ?? _generateId(prefix: 'MH');
    final receipt = PaymentReceiptModel(
      amountPaid: req.totalAmount,
      currency: req.currency,
      method: method,
      bookingId: bookingId,
      paidAt: DateTime.now(),
      invoiceUrl: null, // API-ready: backend will provide URL
    );

    // Update request as paid + attach bookingId for Booking Details linking
    final updated = BookingRequestEntity(
      requestId: req.requestId,
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
      bookingId: bookingId,
    );
    _store.put(updated);

    return receipt;

    // API-ready example:
    // final res = await dio.post('/payments/pay', data: {'requestId': requestId, 'method': method.name});
    // return PaymentReceiptModel.fromJson(res.data);
  }

  String _generateId({required String prefix}) {
    final n = 1000 + _random.nextInt(9000);
    return '$prefix-$n';
  }
}
