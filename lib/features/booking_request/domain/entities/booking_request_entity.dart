import 'package:equatable/equatable.dart';

enum BookingRequestStatus {
  pending,              // بانتظار موافقة الأدمن
  underReview,          // الأدمن يراجع الطلب
  approvedWaitingPayment, // تمت الموافقة، بانتظار الدفع خلال 24 ساعة
  paymentUnderReview,   // تم إرسال الدفع، بانتظار تأكيد الأدمن
  confirmed,            // تم تأكيد الحجز نهائياً
  rejected,             // تم الرفض
  cancelled,            // تم الإلغاء
  expired,              // انتهت مهلة الدفع
  // legacy aliases
  approved,             // قديم → approvedWaitingPayment
  paid,                 // قديم → confirmed
}

enum DurationUnit { days, weeks, months }

class SpaceSummaryEntity extends Equatable {
  final String id;
  final String name;
  final int basePricePerDay; // smallest currency unit not enforced here (dummy)
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
  final int price; // per unit (hour/day) simplified
  final String unitLabel; // e.g. "/ hour"
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
  final String bookingId;
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

  /// UI helper text (API-ready: comes from backend policy/SLAs)
  final String? statusHint;

  final int totalAmount;
  final String currency;

  /// Present after payment (to link to Booking Details feature)


  /// مهلة الدفع: 24 ساعة من وقت الموافقة
  final DateTime? paymentDeadline;
  final DateTime? createdAt;

  const BookingRequestEntity({
    required this.bookingId,
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
    this.paymentDeadline,
    this.createdAt,
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
    bookingId,
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
