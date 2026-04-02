import 'pricing_enums.dart';
import 'user_offer.dart';

class PriceCalcResult {
  final double base;
  final double finalPrice;
  final PriceUnit unit;
  final String label; // e.g. "₪25/day"
  final String? strikeLabel; // old price label if discounted
  final String? note; // bonus or package note

  const PriceCalcResult({
    required this.base,
    required this.finalPrice,
    required this.unit,
    required this.label,
    required this.strikeLabel,
    required this.note,
  });
}

class PriceCalculator {
  static PriceCalcResult apply({
    required double basePrice,
    required PriceUnit baseUnit,
    UserOffer? offer,
    String currencySymbol = '₪',
  }) {
    final base = basePrice;
    double finalP = basePrice;
    PriceUnit unit = baseUnit;
    String? strike;
    String? note;

    if (offer == null || !offer.enabled) {
      return PriceCalcResult(
        base: base,
        finalPrice: basePrice,
        unit: baseUnit,
        label: _fmt(currencySymbol, basePrice, baseUnit),
        strikeLabel: null,
        note: null,
      );
    }

    switch (offer.type) {
      case OfferType.discountPercent:
        final p = offer.discountPercent ?? 0;
        if (p > 0 && p <= 100) {
          strike = _fmt(currencySymbol, basePrice, baseUnit);
          finalP = basePrice * (1 - (p / 100.0));
        }
        break;

      case OfferType.fixedPriceOverride:
        if (offer.fixedPriceValue != null && offer.fixedPriceValue! > 0) {
          strike = _fmt(currencySymbol, basePrice, baseUnit);
          finalP = offer.fixedPriceValue!;
          unit = offer.fixedPriceUnit ?? baseUnit;
        }
        break;

      case OfferType.packageMonths:
        // For user display: we show package note + computed monthly price if possible.
        // If fixedMonthlyPrice provided -> show that as "x/month" (unit=month).
        // Else if packageDiscountPercent -> apply discount on base monthly if baseUnit=month.
        final months = offer.packageMonths ?? 0;
        note = (months > 0) ? 'Package: $months months' : 'Package';
        if (offer.fixedMonthlyPrice != null && offer.fixedMonthlyPrice! > 0) {
          strike = (baseUnit == PriceUnit.month) ? _fmt(currencySymbol, basePrice, PriceUnit.month) : null;
          finalP = offer.fixedMonthlyPrice!;
          unit = PriceUnit.month;
        } else if (offer.packageDiscountPercent != null && offer.packageDiscountPercent! > 0) {
          final disc = offer.packageDiscountPercent!;
          if (baseUnit == PriceUnit.month) {
            strike = _fmt(currencySymbol, basePrice, PriceUnit.month);
            finalP = basePrice * (1 - (disc / 100.0));
            unit = PriceUnit.month;
          } else {
            // If base is not monthly, we still show note only (no conversion).
            note = '$note • ${disc.toStringAsFixed(0)}% off';
          }
        }
        break;

      case OfferType.bonus:
        // Price doesn't change, only note
        note = offer.bonusText;
        break;
    }

    return PriceCalcResult(
      base: base,
      finalPrice: finalP,
      unit: unit,
      label: _fmt(currencySymbol, finalP, unit),
      strikeLabel: strike,
      note: note,
    );
  }

  static String _fmt(String sym, double v, PriceUnit u) {
    final numStr = (v % 1 == 0) ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    return '$sym$numStr/${u.name}';
  }
}
