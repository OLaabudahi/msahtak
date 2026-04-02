import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../data/models/space_details_model.dart';

class OfferCard extends StatelessWidget {
  final SpaceOffer offer;
  const OfferCard({super.key, required this.offer});

  /// âœ… ط¯ط§ظ„ط©: ظ„ظˆظ† badge ط­ط³ط¨ ط§ظ„ظ†ظˆط¹ (limited/bonus)
  Color _badgeColor() {
    switch (offer.badgeType) {
      case 'bonus':
        return AppColors.reviewStatusBg;
      case 'limited':
      default:
        return AppColors.rejectedBg;
    }
  }

  /// âœ… ط¯ط§ظ„ط©: ظ„ظˆظ† ط§ظ„ظ†طµ ط¯ط§ط®ظ„ badge
  Color _badgeTextColor() {
    switch (offer.badgeType) {
      case 'bonus':
        return AppColors.link;
      case 'limited':
      default:
        return AppColors.danger;
    }
  }

  /// âœ… ط¯ط§ظ„ط©: ظƒط§ط±ط¯ ط¹ط±ط¶ ظ…ط«ظ„ ط§ظ„طھطµظ…ظٹظ…
  @override
  Widget build(BuildContext context) {
    final badgeBg = _badgeColor();
    final badgeTx = _badgeTextColor();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              offer.badgeText,
              style: TextStyle(
                color: badgeTx,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            offer.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                offer.priceLine,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              if (offer.oldPriceText != null) ...[
                Text(
                  offer.oldPriceText!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                offer.newPriceText,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            offer.includesText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            offer.validUntilText,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}


