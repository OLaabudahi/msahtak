import '../../domain/entities/offer_duration_unit.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/offer_type.dart';
import '../../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';

class OfferModel {
  final String id;
  final String title;
  final String type; // discountPercent|fixedPriceOverride|packageMonths|bonus
  final String validUntil;
  final bool enabled;

  final int? durationValue;
  final String? durationUnit; // days|weeks|months

  final double? discountPercent;

  final double? fixedPriceValue;
  final String? fixedPriceUnit; // day|week|month

  final int? packageMonths;
  final double? packageDiscountPercent;
  final double? fixedMonthlyPrice;

  final String? bonusText;

  const OfferModel({
    required this.id,
    required this.title,
    required this.type,
    required this.validUntil,
    required this.enabled,
    required this.durationValue,
    required this.durationUnit,
    required this.discountPercent,
    required this.fixedPriceValue,
    required this.fixedPriceUnit,
    required this.packageMonths,
    required this.packageDiscountPercent,
    required this.fixedMonthlyPrice,
    required this.bonusText,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        type: (json['type'] ?? 'discountPercent').toString(),
        validUntil: (json['validUntil'] ?? '').toString(),
        enabled: (json['enabled'] ?? false) == true,
        durationValue: (json['durationValue'] as num?)?.toInt(),
        durationUnit: json['durationUnit']?.toString(),
        discountPercent: (json['discountPercent'] as num?)?.toDouble(),
        fixedPriceValue: (json['fixedPriceValue'] as num?)?.toDouble(),
        fixedPriceUnit: json['fixedPriceUnit']?.toString(),
        packageMonths: (json['packageMonths'] as num?)?.toInt(),
        packageDiscountPercent: (json['packageDiscountPercent'] as num?)?.toDouble(),
        fixedMonthlyPrice: (json['fixedMonthlyPrice'] as num?)?.toDouble(),
        bonusText: json['bonusText']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'validUntil': validUntil,
        'enabled': enabled,
        'durationValue': durationValue,
        'durationUnit': durationUnit,
        'discountPercent': discountPercent,
        'fixedPriceValue': fixedPriceValue,
        'fixedPriceUnit': fixedPriceUnit,
        'packageMonths': packageMonths,
        'packageDiscountPercent': packageDiscountPercent,
        'fixedMonthlyPrice': fixedMonthlyPrice,
        'bonusText': bonusText,
      };

  OfferEntity toEntity() => OfferEntity(
        id: id,
        title: title,
        type: _parseType(type),
        validUntil: validUntil,
        enabled: enabled,
        durationValue: durationValue,
        durationUnit: _parseDurUnit(durationUnit),
        discountPercent: discountPercent,
        fixedPriceValue: fixedPriceValue,
        fixedPriceUnit: _parsePriceUnit(fixedPriceUnit),
        packageMonths: packageMonths,
        packageDiscountPercent: packageDiscountPercent,
        fixedMonthlyPrice: fixedMonthlyPrice,
        bonusText: bonusText,
      );

  static OfferModel fromEntity(OfferEntity e) => OfferModel(
        id: e.id,
        title: e.title,
        type: e.type.name,
        validUntil: e.validUntil,
        enabled: e.enabled,
        durationValue: e.durationValue,
        durationUnit: e.durationUnit?.name,
        discountPercent: e.discountPercent,
        fixedPriceValue: e.fixedPriceValue,
        fixedPriceUnit: e.fixedPriceUnit?.name,
        packageMonths: e.packageMonths,
        packageDiscountPercent: e.packageDiscountPercent,
        fixedMonthlyPrice: e.fixedMonthlyPrice,
        bonusText: e.bonusText,
      );

  OfferType _parseType(String s) {
    switch (s) {
      case 'fixedPriceOverride':
        return OfferType.fixedPriceOverride;
      case 'packageMonths':
        return OfferType.packageMonths;
      case 'bonus':
        return OfferType.bonus;
      default:
        return OfferType.discountPercent;
    }
  }

  OfferDurationUnit? _parseDurUnit(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'weeks':
        return OfferDurationUnit.weeks;
      case 'months':
        return OfferDurationUnit.months;
      case 'days':
        return OfferDurationUnit.days;
      default:
        return null;
    }
  }

  PriceUnit? _parsePriceUnit(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'week':
        return PriceUnit.week;
      case 'month':
        return PriceUnit.month;
      case 'day':
        return PriceUnit.day;
      default:
        return null;
    }
  }
}


