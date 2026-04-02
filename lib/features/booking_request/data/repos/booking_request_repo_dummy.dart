import 'dart:async';
import 'dart:math';

import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';
import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';
import '../sources/booking_in_memory_store.dart';


class BookingRequestRepoDummy implements BookingRequestRepo {
  final BookingInMemoryStore _store;
  final Random _random;

  BookingRequestRepoDummy({BookingInMemoryStore? store, Random? random})
    : _store = store ?? BookingInMemoryStore.instance,
      _random = random ?? Random();

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final int effectiveDays = _toDays(durationUnit, durationValue);
    final int spaceSubtotal = space.basePricePerDay * effectiveDays;

    final int offerDiscount = _calcOfferDiscount(spaceSubtotal, offerId);
    final int addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);

    final int total = max(0, spaceSubtotal - offerDiscount + addOnsTotal);

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total,
      currency: space.currency,
    );

    
    
    
  }

  @override
  Future<BookingRequestEntity> createRequest({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? purposeId,
    required String? purposeLabel,
    required String? offerId,
    required String? offerLabel,
    required List<AddOnEntity> addOns,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final quoteEntity = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );

    final requestId = _generateId(prefix: 'REQ');
    final entity = BookingRequestModel(
      requestId: requestId,
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      purposeId: purposeId,
      purposeLabel: purposeLabel,
      offerId: offerId,
      offerLabel: offerLabel,
      addOns: addOns,
      status: BookingRequestStatus.pending,
      statusHint: 'Usually responds within 1â€“2 hours',
      totalAmount: quoteEntity.total,
      currency: quoteEntity.currency,
      bookingId: null,
    );

    _store.put(entity);
    return entity;

    
    
    
  }

  @override
  Future<BookingRequestEntity> getStatus({required String requestId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final current = _store.get(requestId);
    if (current == null) {
      throw StateError('Request not found');
    }
    return current;

    
    
    
  }

  @override
  Future<BookingRequestEntity> refreshStatus({
    required String requestId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final current = _store.get(requestId);
    if (current == null) {
      throw StateError('Request not found');
    }

    if (current.status == BookingRequestStatus.pending) {
      final updated = _copyRequest(
        current,
        status: BookingRequestStatus.underReview,
      );
      _store.put(updated);
      return updated;
    }

    if (current.status == BookingRequestStatus.underReview) {
      
      final shouldApprove = _random.nextInt(10) < 7;
      if (shouldApprove) {
        final updated = _copyRequest(
          current,
          status: BookingRequestStatus.approved,
          statusHint: 'Proceed to payment',
        );
        _store.put(updated);
        return updated;
      }
      return current;
    }

    return current;

    
    
    
  }

  @override
  Future<BookingRequestEntity> cancel({required String requestId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final current = _store.get(requestId);
    if (current == null) {
      throw StateError('Request not found');
    }
    if (!current.canCancelBeforeApproval) {
      throw StateError('Cancellation is not allowed after approval');
    }

    final updated = _copyRequest(
      current,
      status: BookingRequestStatus.cancelled,
      statusHint: 'Request cancelled',
    );
    _store.put(updated);
    return updated;

    
    
    
  }

  BookingRequestEntity _copyRequest(
    BookingRequestEntity current, {
    required BookingRequestStatus status,
    String? statusHint,
    String? bookingId,
  }) {
    return BookingRequestModel(
      requestId: current.requestId,
      space: current.space,
      startDate: current.startDate,
      durationUnit: current.durationUnit,
      durationValue: current.durationValue,
      purposeId: current.purposeId,
      purposeLabel: current.purposeLabel,
      offerId: current.offerId,
      offerLabel: current.offerLabel,
      addOns: current.addOns,
      status: status,
      statusHint: statusHint ?? current.statusHint,
      totalAmount: current.totalAmount,
      currency: current.currency,
      bookingId: bookingId ?? current.bookingId,
    );
  }

  int _toDays(DurationUnit unit, int value) {
    switch (unit) {
      case DurationUnit.days:
        return value;
      case DurationUnit.weeks:
        return value * 7;
      case DurationUnit.months:
        return value * 30;
    }
  }

  int _calcOfferDiscount(int subtotal, String? offerId) {
    if (offerId == null) return 0;
    
    if (offerId == 'WEEKLY') return (subtotal * 0.10).round();
    if (offerId == 'MONTHLY') return (subtotal * 0.15).round();
    return (subtotal * 0.05).round();
  }

  String _generateId({required String prefix}) {
    final n = 1000 + _random.nextInt(9000);
    return '$prefix-$n';
  }
}
