import '../entities/booking_price_quote_entity.dart';
import '../entities/booking_request_entity.dart';

abstract class BookingRequestRepo {
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  });

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
  });

  Future<BookingRequestEntity> getStatus({required String bookingId});

  Future<BookingRequestEntity> refreshStatus({required String bookingId});

  Future<BookingRequestEntity> cancel({
    required String bookingId,
    required String reason,
  });
}

