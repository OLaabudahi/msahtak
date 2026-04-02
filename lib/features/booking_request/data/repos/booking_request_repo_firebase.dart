import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';

import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';
import '../sources/booking_request_firebase_source.dart';

class BookingRequestRepoFirebase implements BookingRequestRepo {
  final BookingRequestFirebaseSource source;

  BookingRequestRepoFirebase({required this.source});

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    final days = _toDays(durationUnit, durationValue);

    final spaceSubtotal = space.basePricePerDay * days;

    final offerDiscount = _calcOfferDiscount(spaceSubtotal, offerId);

    final addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);

    final total =
    (spaceSubtotal - offerDiscount + addOnsTotal).clamp(0, 999999999);

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total.toInt(),
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
    final userId = source.currentUserId;
    final userName = source.currentUserName;

    final bookingId =
        "BID-${DateTime.now().millisecondsSinceEpoch}";

    final quoteResult = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );

    final endDate =
    startDate.add(Duration(days: _toDays(durationUnit, durationValue)));

    /// ًں”¥ ط§ط³طھط®ط¯ط§ظ… Model
    final model = BookingRequestModel(
      bookingId: bookingId,
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
      statusHint: 'Pending approval',
      totalAmount: quoteResult.total,
      currency: quoteResult.currency,
    );

    /// ًں”¥ ط¯ظ…ط¬ ط¨ظٹط§ظ†ط§طھ ط¥ط¶ط§ظپظٹط© ظ…ط¹ model
    final data = {
      ...model.toMap(),
      'userId': userId,
      'userName': userName,
      'spaceId': space.id,
      'spaceName': space.name,
      'endDate': endDate,
      'createdAt': DateTime.now(),
    };

    /// ًں”¥ طھط®ط²ظٹظ† ط¹ط¨ط± Source
    await source.createBooking(
      bookingId: bookingId,
      data: data,
    );

    return model;
  }

  @override
  Future<BookingRequestEntity> getStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
  }

  @override
  Future<BookingRequestEntity> refreshStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
  }

  @override
  Future<BookingRequestEntity> cancel({
    required String bookingId,
  }) async {
    await source.updateBooking(
      id: bookingId,
      data: {
        'status': 'cancelled',
        'updatedAt': DateTime.now(),
      },
    );

    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
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
}
/*
import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';
import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';
import '../sources/booking_request_firebase_source.dart';

class BookingRequestRepoFirebase implements BookingRequestRepo {
  final BookingRequestFirebaseSource source;

  BookingRequestRepoFirebase({required this.source});

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    final days = _toDays(durationUnit, durationValue);

    final spaceSubtotal = space.basePricePerDay * days;

    final offerDiscount = _calcOfferDiscount(spaceSubtotal, offerId);

    final addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);

    final total =
    (spaceSubtotal - offerDiscount + addOnsTotal).clamp(0, 999999999);

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total.toInt(),
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
    final userId = source.currentUserId;
    final userName = source.currentUserName;

    final quoteResult = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );

    final endDate =
    startDate.add(Duration(days: _toDays(durationUnit, durationValue)));

    final data = {
      'userId': userId,
      'userName': userName,
      'spaceId': space.id,
      'spaceName': space.name,
      'startDate': startDate,
      'endDate': endDate,
      'durationUnit': durationUnit.name,
      'durationValue': durationValue,
      'purposeId': purposeId,
      'purposeLabel': purposeLabel,
      'offerId': offerId,
      'offerLabel': offerLabel,
      'totalPrice': quoteResult.total,
      'currency': space.currency,
      'status': 'pending',
      'createdAt': DateTime.now(),
    };

    final id = await source.createBooking(data: data);

    return BookingRequestModel(
      bookingId: id,
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
      statusHint: 'Pending approval',
      totalAmount: quoteResult.total,
      currency: quoteResult.currency,
      bookingId: id,
    );
  }

  @override
  Future<BookingRequestEntity> getStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);
    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromJson(data);
  }

  @override
  Future<BookingRequestEntity> refreshStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);
    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromJson(data);
  }

  @override
  Future<BookingRequestEntity> cancel({
    required String bookingId,
  }) async {
    await source.updateBooking(
      id: bookingId,
      data: {'status': 'cancelled'},
    );

    final data = await source.getBooking(bookingId);
    return BookingRequestModel.fromJson(data!);
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
}*/


