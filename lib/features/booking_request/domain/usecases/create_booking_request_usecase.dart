import '../entities/booking_request_entity.dart';
import '../repos/booking_request_repo.dart';

class CreateBookingRequestUseCase {
  final BookingRequestRepo repo;

  const CreateBookingRequestUseCase(this.repo);

  Future<BookingRequestEntity> call({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? purposeId,
    required String? purposeLabel,
    required String? offerId,
    required String? offerLabel,
    required List<AddOnEntity> addOns,
  }) {
    return repo.createRequest(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      purposeId: purposeId,
      purposeLabel: purposeLabel,
      offerId: offerId,
      offerLabel: offerLabel,
      addOns: addOns,
    );
  }
}


