import 'package:flutter/material.dart';
import '../../../admin/_shared/admin_ui.dart'; // using same SF Pro text + spacing/colors
import '../../../../core/pricing/price_calc.dart';
import '../../../../core/pricing/pricing_enums.dart';
import '../../../../core/pricing/user_offer.dart';

class OfferPricePreview extends StatelessWidget {
  final double basePrice;
  final PriceUnit baseUnit;
  final List<UserOffer> offers;
  final String currencySymbol;

  /// returns selected offer id (IDs only)
  final ValueChanged<String?> onSelectedOfferChanged;
  final String? selectedOfferId;

  const OfferPricePreview({
    super.key,
    required this.basePrice,
    required this.baseUnit,
    required this.offers,
    required this.currencySymbol,
    required this.onSelectedOfferChanged,
    required this.selectedOfferId,
  });

  @override
  Widget build(BuildContext context) {
    final enabledOffers = offers.where((o) => o.enabled).toList(growable: false);
    final selected = enabledOffers.where((o) => o.id == selectedOfferId).isNotEmpty
        ? enabledOffers.firstWhere((o) => o.id == selectedOfferId)
        : null;

    final calc = PriceCalculator.apply(
      basePrice: basePrice,
      baseUnit: baseUnit,
      offer: selected,
      currencySymbol: currencySymbol,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price row like the UI (strike + final)
        Row(
          children: [
            if (calc.strikeLabel != null) ...[
              Text(
                calc.strikeLabel!,
                style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600).copyWith(decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: 8),
            ],
            Text(calc.label, style: AdminText.body16(w: FontWeight.w800)),
            const Spacer(),
            if (calc.note != null && calc.note!.trim().isNotEmpty)
              Text(calc.note!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w700)),
          ],
        ),

        const SizedBox(height: 12),

        // Offers list (tap to select)
        if (enabledOffers.isEmpty)
          Text('No offers available', style: AdminText.body14(color: AdminColors.black40))
        else
          Column(
            children: enabledOffers.map((o) {
              final active = o.id == selectedOfferId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => onSelectedOfferChanged(active ? null : o.id),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AdminColors.bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: active ? AdminColors.primaryAmber : AdminColors.black15, width: 1),
                    ),
                    child: Row(
                      children: [
                        _Tag(type: o.type),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text(_sub(o, currencySymbol), maxLines: 2, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, size: 20, color: active ? AdminColors.primaryAmber : AdminColors.black15),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
      ],
    );
  }

  static String _sub(UserOffer o, String sym) {
    switch (o.type) {
      case OfferType.discountPercent:
        final p = o.discountPercent?.toStringAsFixed(0) ?? '--';
        return 'Offer: $p% off';
      case OfferType.fixedPriceOverride:
        final v = o.fixedPriceValue?.toStringAsFixed(0) ?? '--';
        final u = o.fixedPriceUnit?.name ?? 'day';
        return 'Price: $sym$v/$u';
      case OfferType.packageMonths:
        final m = o.packageMonths ?? 0;
        final dp = o.packageDiscountPercent;
        final mp = o.fixedMonthlyPrice;
        if (mp != null && mp > 0) return 'Package $m months • $sym${mp.toStringAsFixed(0)}/month';
        if (dp != null && dp > 0) return 'Package $m months • ${dp.toStringAsFixed(0)}% off';
        return 'Package $m months';
      case OfferType.bonus:
        return o.bonusText ?? 'Bonus';
    }
  }
}

class _Tag extends StatelessWidget {
  final OfferType type;
  const _Tag({required this.type});

  @override
  Widget build(BuildContext context) {
    final text = (type == OfferType.bonus) ? 'BONUS' : 'LIMITED';
    final c = (type == OfferType.bonus) ? AdminColors.primaryBlue : AdminColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.15), width: 1),
      ),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: c, w: FontWeight.w800)),
    );
  }
}


