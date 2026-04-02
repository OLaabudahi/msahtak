import 'pricing_enums.dart';

class UserOffer {
  final String id;
  final String title;
  final OfferType type;
  final String validUntil;
  final bool enabled;

  final int? durationValue;
  final OfferDurationUnit? durationUnit;

  final double? discountPercent;

  final double? fixedPriceValue;
  final PriceUnit? fixedPriceUnit;

  final int? packageMonths; 
  final double? packageDiscountPercent;
  final double? fixedMonthlyPrice;

  final String? bonusText;

  const UserOffer({
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

  
  factory UserOffer.fromJson(Map<String, dynamic> json) {
    final type = _parseType(json['type']?.toString());
    return UserOffer(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      type: type,
      validUntil: (json['validUntil'] ?? '').toString(),
      enabled: (json['enabled'] ?? false) == true,
      durationValue: (json['durationValue'] as num?)?.toInt(),
      durationUnit: _parseDurUnit(json['durationUnit']?.toString()),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      fixedPriceValue: (json['fixedPriceValue'] as num?)?.toDouble(),
      fixedPriceUnit: _parsePriceUnit(json['fixedPriceUnit']?.toString()),
      packageMonths: (json['packageMonths'] as num?)?.toInt(),
      packageDiscountPercent: (json['packageDiscountPercent'] as num?)?.toDouble(),
      fixedMonthlyPrice: (json['fixedMonthlyPrice'] as num?)?.toDouble(),
      bonusText: json['bonusText']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'validUntil': validUntil,
        'enabled': enabled,
        'durationValue': durationValue,
        'durationUnit': durationUnit?.name,
        'discountPercent': discountPercent,
        'fixedPriceValue': fixedPriceValue,
        'fixedPriceUnit': fixedPriceUnit?.name,
        'packageMonths': packageMonths,
        'packageDiscountPercent': packageDiscountPercent,
        'fixedMonthlyPrice': fixedMonthlyPrice,
        'bonusText': bonusText,
      };

  static OfferType _parseType(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'fixedpriceoverride':
        return OfferType.fixedPriceOverride;
      case 'packagemonths':
        return OfferType.packageMonths;
      case 'bonus':
        return OfferType.bonus;
      case 'discountpercent':
      default:
        return OfferType.discountPercent;
    }
  }

  static OfferDurationUnit? _parseDurUnit(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'days':
        return OfferDurationUnit.days;
      case 'weeks':
        return OfferDurationUnit.weeks;
      case 'months':
        return OfferDurationUnit.months;
      default:
        return null;
    }
  }

  static PriceUnit? _parsePriceUnit(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'day':
        return PriceUnit.day;
      case 'week':
        return PriceUnit.week;
      case 'month':
        return PriceUnit.month;
      default:
        return null;
    }
  }
}
