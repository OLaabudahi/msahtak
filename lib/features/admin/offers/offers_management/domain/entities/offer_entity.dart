import 'package:equatable/equatable.dart';
import '../../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';
import 'offer_duration_unit.dart';
import 'offer_type.dart';

class OfferEntity extends Equatable {
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


