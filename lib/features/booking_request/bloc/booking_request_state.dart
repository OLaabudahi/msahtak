import 'package:equatable/equatable.dart';

import '../domain/entities/booking_price_quote_entity.dart';
import '../domain/entities/booking_request_entity.dart';


enum BookingRequestUiStatus {
  initial,
  loading,
  ready,
  quoting,
  submitting,
  success,
  failure,
}

class BookingRequestState extends Equatable {
  final BookingRequestUiStatus uiStatus;
  final String? errorMessage;

  // Form base
  final SpaceSummaryEntity? space;
  final DateTime? startDate;
  final DurationUnit durationUnit;
  final int durationValue;

  final String? purposeId;
  final String? purposeLabel;

  final String? offerId;
  final String? offerLabel;

  final List<AddOnEntity> addOns;

  // Derived / Result
  final BookingPriceQuoteEntity? quote;
  final BookingRequestEntity? createdRequest;

  const BookingRequestState({
    required this.uiStatus,
    required this.errorMessage,
    required this.space,
    required this.startDate,
    required this.durationUnit,
    required this.durationValue,
    required this.purposeId,
    required this.purposeLabel,
    required this.offerId,
    required this.offerLabel,
    required this.addOns,
    required this.quote,
    required this.createdRequest,
  });

  factory BookingRequestState.initial() {
    return const BookingRequestState(
      uiStatus: BookingRequestUiStatus.initial,
      errorMessage: null,
      space: null,
      startDate: null,
      durationUnit: DurationUnit.days,
      durationValue: 1,
      purposeId: null,
      purposeLabel: null,
      offerId: null,
      offerLabel: null,
      addOns: <AddOnEntity>[],
      quote: null,
      createdRequest: null,
    );
  }

  bool get canSubmit {
    if (space == null) return false;
    if (startDate == null) return false;
    if (durationValue <= 0) return false;
    return true;
  }

  BookingRequestState copyWith({
    BookingRequestUiStatus? uiStatus,
    String? errorMessage,
    SpaceSummaryEntity? space,
    DateTime? startDate,
    DurationUnit? durationUnit,
    int? durationValue,
    String? purposeId,
    String? purposeLabel,
    String? offerId,
    String? offerLabel,
    List<AddOnEntity>? addOns,
    BookingPriceQuoteEntity? quote,
    BookingRequestEntity? createdRequest,
    bool clearError = false,
  }) {
    return BookingRequestState(
      uiStatus: uiStatus ?? this.uiStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      space: space ?? this.space,
      startDate: startDate ?? this.startDate,
      durationUnit: durationUnit ?? this.durationUnit,
      durationValue: durationValue ?? this.durationValue,
      purposeId: purposeId ?? this.purposeId,
      purposeLabel: purposeLabel ?? this.purposeLabel,
      offerId: offerId ?? this.offerId,
      offerLabel: offerLabel ?? this.offerLabel,
      addOns: addOns ?? this.addOns,
      quote: quote ?? this.quote,
      createdRequest: createdRequest ?? this.createdRequest,
    );
  }

  @override
  List<Object?> get props => [
    uiStatus,
    errorMessage,
    space,
    startDate,
    durationUnit,
    durationValue,
    purposeId,
    purposeLabel,
    offerId,
    offerLabel,
    addOns,
    quote,
    createdRequest,
  ];
}
