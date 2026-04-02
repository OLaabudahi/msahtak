import 'package:equatable/equatable.dart';

enum BookingRequestStatus {
  pending,              
  underReview,          
  approvedWaitingPayment, 
  paymentUnderReview,   
  confirmed,            
  rejected,             
  cancelled,            
  expired,              
  
  approved,             
  paid,                 
}

enum DurationUnit { days, weeks, months }

class SpaceSummaryEntity extends Equatable {
  final String id;
  final String name;
  final int basePricePerDay; 
  final String currency;

  const SpaceSummaryEntity({
    required this.id,
    required this.name,
    required this.basePricePerDay,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, name, basePricePerDay, currency];
}

class AddOnEntity extends Equatable {
  final String id;
  final String title;
  final int price; 
  final String unitLabel; 
  final bool isSelected;

  const AddOnEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.unitLabel,
    required this.isSelected,
  });

  AddOnEntity copyWith({bool? isSelected}) {
    return AddOnEntity(
      id: id,
      title: title,
      price: price,
      unitLabel: unitLabel,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, title, price, unitLabel, isSelected];
}

class BookingRequestEntity extends Equatable {
  final String requestId;
  final SpaceSummaryEntity space;
  final DateTime startDate;
  final DurationUnit durationUnit;
  final int durationValue;

  final String? purposeId;
  final String? purposeLabel;

  final String? offerId;
  final String? offerLabel;

  final List<AddOnEntity> addOns;

  final BookingRequestStatus status;

  
  final String? statusHint;

  final int totalAmount;
  final String currency;

  
  final String? bookingId;

  
  final DateTime? paymentDeadline;

  const BookingRequestEntity({
    required this.requestId,
    required this.space,
    required this.startDate,
    required this.durationUnit,
    required this.durationValue,
    required this.purposeId,
    required this.purposeLabel,
    required this.offerId,
    required this.offerLabel,
    required this.addOns,
    required this.status,
    required this.statusHint,
    required this.totalAmount,
    required this.currency,
    required this.bookingId,
    this.paymentDeadline,
  });

  bool get canCancelBeforeApproval =>
      status == BookingRequestStatus.pending ||
      status == BookingRequestStatus.underReview;

  bool get isApproved =>
      status == BookingRequestStatus.approvedWaitingPayment ||
      status == BookingRequestStatus.approved ||
      status == BookingRequestStatus.paymentUnderReview ||
      status == BookingRequestStatus.confirmed ||
      status == BookingRequestStatus.paid;

  bool get isDeadlineExpired {
    if (paymentDeadline == null) return false;
    return DateTime.now().isAfter(paymentDeadline!);
  }

  @override
  List<Object?> get props => [
    requestId,
    space,
    startDate,
    durationUnit,
    durationValue,
    purposeId,
    purposeLabel,
    offerId,
    offerLabel,
    addOns,
    status,
    statusHint,
    totalAmount,
    currency,
    bookingId,
    paymentDeadline,
  ];
}
