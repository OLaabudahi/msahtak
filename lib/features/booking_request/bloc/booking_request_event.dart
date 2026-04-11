import 'package:equatable/equatable.dart';

import '../domain/entities/booking_request_entity.dart';


sealed class BookingRequestEvent extends Equatable {
  const BookingRequestEvent();

  @override
  List<Object?> get props => [];
}

class BookingRequestStarted extends BookingRequestEvent {
  final SpaceSummaryEntity space;
  final List<AddOnEntity> availableAddOns;

  const BookingRequestStarted({
    required this.space,
    required this.availableAddOns,
  });

  @override
  List<Object?> get props => [space, availableAddOns];
}

class PurposeChanged extends BookingRequestEvent {
  final String? purposeId;
  final String? purposeLabel;

  const PurposeChanged({required this.purposeId, required this.purposeLabel});

  @override
  List<Object?> get props => [purposeId, purposeLabel];
}

class StartDateChanged extends BookingRequestEvent {
  final DateTime startDate;

  const StartDateChanged(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

class DurationUnitChanged extends BookingRequestEvent {
  final DurationUnit unit;

  const DurationUnitChanged(this.unit);

  @override
  List<Object?> get props => [unit];
}

class BookingRequestStatusOpened extends BookingRequestEvent {
  final String requestId;

  const BookingRequestStatusOpened(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class DurationValueChanged extends BookingRequestEvent {
  final int value;

  const DurationValueChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class OfferChanged extends BookingRequestEvent {
  final String? offerId;
  final String? offerLabel;

  const OfferChanged({required this.offerId, required this.offerLabel});

  @override
  List<Object?> get props => [offerId, offerLabel];
}

class AddOnToggled extends BookingRequestEvent {
  final String addOnId;
  final bool isSelected;

  const AddOnToggled({required this.addOnId, required this.isSelected});

  @override
  List<Object?> get props => [addOnId, isSelected];
}

class SubmitBookingRequestPressed extends BookingRequestEvent {
  const SubmitBookingRequestPressed();
}

class StatusRefreshRequested extends BookingRequestEvent {
  final String requestId;

  const StatusRefreshRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class CancelRequestPressed extends BookingRequestEvent {
  final String requestId;
  final String reason;

  const CancelRequestPressed(this.requestId, {required this.reason});

  @override
  List<Object?> get props => [requestId, reason];
}

