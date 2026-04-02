import 'package:equatable/equatable.dart';
import '../../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';
import 'offer_duration_unit.dart';
import 'offer_type.dart';

class OfferEntity extends Equatable {
  final String id;
  final String title;
  final OfferType type;

  // validity
  final String validUntil; // "Sep 30" (keep string for UI)
  final bool enabled;

  // duration (for limited offers)
  final int? durationValue; // e.g. 7
  final OfferDurationUnit? durationUnit; // days/weeks/months

  // discount
  final double? discountPercent;

  // fixed price override
  final double? fixedPriceValue;
  final PriceUnit? fixedPriceUnit;

  // packages
  final int? packageMonths; // 3/6/9/12
  final double? packageDiscountPercent; // optional
  final double? fixedMonthlyPrice; // optional

  // bonus
  final String? bonusText;

  const OfferEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        validUntil,
        enabled,
        durationValue,
        durationUnit,
        discountPercent,
        fixedPriceValue,
        fixedPriceUnit,
        packageMonths,
        packageDiscountPercent,
        fixedMonthlyPrice,
        bonusText,
      ];
}


