import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_request_entity.dart';

class BookingRequestModel extends BookingRequestEntity {
  const BookingRequestModel({
    required super.bookingId,
    required super.space,
    required super.startDate,
    required super.durationUnit,
    required super.durationValue,
    required super.purposeId,
    required super.purposeLabel,
    required super.offerId,
    required super.offerLabel,
    required super.addOns,
    required super.status,
    required super.statusHint,
    required super.totalAmount,
    required super.currency,
    super.paymentDeadline,
    super.createdAt,
    super.cancelReason,
    super.cancellationStage,
    super.cancelledAt,
    super.cancelledBy,
    super.paymentReceiptUrl,
  });

  factory BookingRequestModel.fromMap(Map<String, dynamic> json) {
    final rawSpace = json['space'] ?? json['spaceSnapshot'] ?? const <String, dynamic>{};
    final spaceJson = rawSpace is Map
        ? Map<String, dynamic>.from(rawSpace)
        : <String, dynamic>{};

    final spaceId = (spaceJson['id'] ?? json['spaceId'] ?? json['space_id'] ?? '').toString();
    final spaceName = (spaceJson['name'] ?? json['spaceName'] ?? json['workspaceName'] ?? '').toString();
    final spaceCurrency = (spaceJson['currency'] ?? json['currency'] ?? '₪').toString();
    final basePrice = ((spaceJson['basePricePerDay'] ?? json['basePricePerDay'] ?? 0) as num).toInt();

    return BookingRequestModel(
      bookingId: (json['bookingId'] ?? json['id'] ?? '').toString(),
      paymentDeadline: _toDateTime(json['paymentDeadline']),
      createdAt: _toDateTime(json['createdAt']),
      cancelReason: (json['cancelReason'] ?? '').toString().trim().isEmpty
          ? null
          : (json['cancelReason']).toString(),
      cancellationStage: (json['cancellationStage'] ?? '').toString().trim().isEmpty
          ? null
          : (json['cancellationStage']).toString(),
      cancelledAt: _toDateTime(json['cancelledAt']),
      cancelledBy: _parseCancelledBy(json['cancelledBy']),
      paymentReceiptUrl: (json['paymentReceiptUrl'] ?? '').toString().trim().isEmpty
          ? null
          : (json['paymentReceiptUrl']).toString(),
      space: SpaceSummaryEntity(
        id: spaceId,
        name: spaceName.isEmpty ? 'Space' : spaceName,
        basePricePerDay: basePrice,
        currency: spaceCurrency,
      ),
      startDate: _toDateTime(json['startDate']) ?? DateTime.now(),
      durationUnit: _parseDurationUnit((json['durationUnit'] ?? 'days').toString()),
      durationValue: ((json['durationValue'] ?? 1) as num).toInt(),
      purposeId: json['purposeId'] as String?,
      purposeLabel: json['purposeLabel'] as String?,
      offerId: json['offerId'] as String?,
      offerLabel: json['offerLabel'] as String?,
      addOns: ((json['addOns'] as List<dynamic>?) ?? const [])
          .map(
            (item) => AddOnEntity(
              id: (item['id'] ?? '').toString(),
              title: (item['title'] ?? '').toString(),
              price: ((item['price'] ?? 0) as num).toInt(),
              unitLabel: (item['unitLabel'] ?? '').toString(),
              isSelected: (item['isSelected'] as bool?) ?? false,
            ),
          )
          .toList(growable: false),
      status: _parseStatus((json['status'] ?? 'pending').toString()),
      statusHint: json['statusHint'] as String?,
      totalAmount: ((json['totalAmount'] ?? 0) as num).toInt(),
      currency: (json['currency'] ?? '₪').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'bookingId': bookingId,
        'space': {
          'id': space.id,
          'name': space.name,
          'basePricePerDay': space.basePricePerDay,
          'currency': space.currency,
        },
        'startDate': Timestamp.fromDate(startDate),
        'durationUnit': durationUnit.name,
        'durationValue': durationValue,
        'purposeId': purposeId,
        'purposeLabel': purposeLabel,
        'offerId': offerId,
        'offerLabel': offerLabel,
        'addOns': addOns
            .map(
              (a) => {
                'id': a.id,
                'title': a.title,
                'price': a.price,
                'unitLabel': a.unitLabel,
                'isSelected': a.isSelected,
              },
            )
            .toList(growable: false),
        'status': status.name,
        'statusHint': statusHint,
        'totalAmount': totalAmount,
        'currency': currency,
        'createdAt': createdAt ?? DateTime.now(),
        'paymentDeadline': paymentDeadline != null
            ? Timestamp.fromDate(paymentDeadline!)
            : null,
        'cancelReason': cancelReason,
        'cancellationStage': cancellationStage,
        'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
        'cancelledBy': cancelledBy,
        'paymentReceiptUrl': paymentReceiptUrl,
      };

  static BookingRequestStatus _parseStatus(String raw) {
    final normalized = raw.trim().toLowerCase();
    switch (normalized) {
      case 'pending':
        return BookingRequestStatus.pending;
      case 'underreview':
      case 'under_review':
      case 'under-review':
        return BookingRequestStatus.underReview;
      case 'approvedwaitingpayment':
      case 'approved_waiting_payment':
      case 'awaitingpayment':
      case 'awaiting_payment':
        return BookingRequestStatus.approvedWaitingPayment;
      case 'paymentunderreview':
      case 'payment_under_review':
        return BookingRequestStatus.paymentUnderReview;
      case 'paymentrejected':
      case 'payment_rejected':
        return BookingRequestStatus.paymentRejected;
      case 'confirmed':
        return BookingRequestStatus.confirmed;
      case 'active':
        return BookingRequestStatus.active;
      case 'completed':
        return BookingRequestStatus.completed;
      case 'rejected':
        return BookingRequestStatus.rejected;
      case 'cancelled':
      case 'canceled':
        return BookingRequestStatus.cancelled;
      case 'expired':
        return BookingRequestStatus.expired;
      case 'approved':
        return BookingRequestStatus.approved;
      case 'paid':
        return BookingRequestStatus.paid;
      default:
        return BookingRequestStatus.pending;
    }
  }

  static DurationUnit _parseDurationUnit(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'weeks':
        return DurationUnit.weeks;
      case 'months':
        return DurationUnit.months;
      default:
        return DurationUnit.days;
    }
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static String? _parseCancelledBy(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      final name = value['name']?.toString();
      if (name != null && name.isNotEmpty) return name;
      final role = value['role']?.toString();
      if (role != null && role.isNotEmpty) return role;
    }
    return null;
  }
}
