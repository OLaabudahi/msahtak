import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/offer_entity.dart';
import '../domain/entities/offer_type.dart';

class OfferCard extends StatelessWidget {
  final OfferEntity offer;
  final ValueChanged<bool> onToggle;

  const OfferCard({super.key, required this.offer, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final tag = _tagFor(offer);
    final tagColor = _tagColor(offer);

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (tag != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: tagColor.withOpacity(0.15), width: 1),
                  ),
                  child: Text(tag, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: tagColor, w: FontWeight.w800)),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(offer.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w800)),
              ),
              Switch(
                value: offer.enabled,
                onChanged: onToggle,
                activeColor: AdminColors.primaryBlue,
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(_subtitle(offer), maxLines: 3, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600)),

          const SizedBox(height: 10),
          Row(
            children: [
              Text('Valid until: ', style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w700)),
              Expanded(child: Text(offer.validUntil, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.text, w: FontWeight.w700))),
            ],
          ),
        ],
      ),
    );
  }

  String _subtitle(OfferEntity o) {
    switch (o.type) {
      case OfferType.discountPercent:
        final dur = (o.durationValue != null && o.durationUnit != null) ? ' • ${o.durationValue} ${o.durationUnit!.name}' : '';
        return 'Discount: ${o.discountPercent?.toStringAsFixed(0) ?? '--'}%$dur';

      case OfferType.fixedPriceOverride:
        return 'Fixed price: ${o.fixedPriceValue?.toStringAsFixed(0) ?? '--'}/${o.fixedPriceUnit?.name ?? 'day'}';

      case OfferType.packageMonths:
        final m = o.packageMonths ?? 0;
        final dp = o.packageDiscountPercent;
        final mp = o.fixedMonthlyPrice;
        if (dp != null && dp > 0) return 'Package: $m months • Discount: ${dp.toStringAsFixed(0)}%';
        if (mp != null && mp > 0) return 'Package: $m months • Fixed monthly: ${mp.toStringAsFixed(0)}/month';
        return 'Package: $m months';

      case OfferType.bonus:
        return 'Bonus: ${o.bonusText ?? ''}';
    }
  }

  String? _tagFor(OfferEntity o) {
    switch (o.type) {
      case OfferType.fixedPriceOverride:
      case OfferType.discountPercent:
      case OfferType.packageMonths:
        return 'LIMITED';
      case OfferType.bonus:
        return 'BONUS';
    }
  }

  Color _tagColor(OfferEntity o) {
    switch (o.type) {
      case OfferType.bonus:
        return AdminColors.primaryBlue;
      default:
        return AdminColors.danger;
    }
  }
}
