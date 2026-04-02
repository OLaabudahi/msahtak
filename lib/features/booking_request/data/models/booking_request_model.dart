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
  });

  /// =========================
  /// FROM MAP (Firebase)
  /// =========================
  factory BookingRequestModel.fromMap(Map<String, dynamic> json) {
    final spaceJson = json['space'] as Map<String, dynamic>;

    return BookingRequestModel(
      bookingId: json['bookingId'],


      paymentDeadline: json['paymentDeadline'] != null
          ? (json['paymentDeadline'] as Timestamp).toDate()
          : null,

      space: SpaceSummaryEntity(
        id: spaceJson['id'] as String,
        name: spaceJson['name'] as String,
        basePricePerDay: (spaceJson['basePricePerDay'] as num).toInt(),
        currency: spaceJson['currency'] as String,
      ),

      startDate: (json['startDate'] as Timestamp).toDate(),

      durationUnit: DurationUnit.values.byName(json['durationUnit'] as String),

      durationValue: (json['durationValue'] as num).toInt(),

      purposeId: json['purposeId'] as String?,
      purposeLabel: json['purposeLabel'] as String?,

      offerId: json['offerId'] as String?,
      offerLabel: json['offerLabel'] as String?,

      addOns: (json['addOns'] as List<dynamic>)
          .map(
            (e) => AddOnEntity(
              id: (e as Map<String, dynamic>)['id'] as String,
              title: e['title'] as String,
              price: (e['price'] as num).toInt(),
              unitLabel: e['unitLabel'] as String,
              isSelected: e['isSelected'] as bool,
            ),
          )
          .toList(growable: false),

      status: BookingRequestStatus.values.byName(json['status'] as String),

      statusHint: json['statusHint'] as String?,

      totalAmount: (json['totalAmount'] as num).toInt(),

      currency: json['currency'] as String,
    );
  }

  /// =========================
  /// TO MAP (Firebase)
  /// =========================
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
    'createdAt': DateTime.now(),

    'paymentDeadline': paymentDeadline != null
        ? Timestamp.fromDate(paymentDeadline!)
        : null,
  };
}

/*
import '../../domain/entities/booking_request_entity.dart';

class BookingRequestModel extends BookingRequestEntity {
  const BookingRequestModel({
    required super.requestId,
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
    required super.bookingId,
    super.paymentDeadline,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      requestId: json['requestId'] as String,
      space: SpaceSummaryEntity(
        id: (json['space'] as Map<String, dynamic>)['id'] as String,
        name: (json['space'] as Map<String, dynamic>)['name'] as String,
        basePricePerDay:
            ((json['space'] as Map<String, dynamic>)['basePricePerDay'] as num)
                .toInt(),
        currency: (json['space'] as Map<String, dynamic>)['currency'] as String,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      durationUnit: DurationUnit.values.byName(json['durationUnit'] as String),
      durationValue: (json['durationValue'] as num).toInt(),
      purposeId: json['purposeId'] as String?,
      purposeLabel: json['purposeLabel'] as String?,
      offerId: json['offerId'] as String?,
      offerLabel: json['offerLabel'] as String?,
      addOns: (json['addOns'] as List<dynamic>)
          .map(
            (e) => AddOnEntity(
              id: (e as Map<String, dynamic>)['id'] as String,
              title: e['title'] as String,
              price: (e['price'] as num).toInt(),
              unitLabel: e['unitLabel'] as String,
              isSelected: e['isSelected'] as bool,
            ),
          )
          .toList(growable: false),
      status: BookingRequestStatus.values.byName(json['status'] as String),
      statusHint: json['statusHint'] as String?,
      totalAmount: (json['totalAmount'] as num).toInt(),
      currency: json['currency'] as String,
      bookingId: json['bookingId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'space': {
      'id': space.id,
      'name': space.name,
      'basePricePerDay': space.basePricePerDay,
      'currency': space.currency,
    },
    'startDate': startDate,
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
    'bookingId': bookingId,
  };
}
*/


