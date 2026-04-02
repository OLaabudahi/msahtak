import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/plan_option.dart';

class PlanItemTile extends StatelessWidget {
  final PlanOption plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanItemTile({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isSelected
            ? const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4)
            : const EdgeInsets.symmetric(
                horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : AppColors.secondaryTint8,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.black87, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(plan.name,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black)),
            ),
            Text(plan.priceLabel,
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary)),
            if (plan.isBest) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Best',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


