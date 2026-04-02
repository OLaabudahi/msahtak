import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;
  final ValueChanged<int>? onDotTap;

  const StepIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final isActive = i == activeIndex;
          final color = isActive ? AppColors.dotActive : AppColors.dotInactive;
          return Padding(
            padding: EdgeInsets.only(right: i == count - 1 ? 0 : AppSpacing.sm),
            child: InkWell(
              onTap: onDotTap == null ? null : () => onDotTap!(i),
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          );
        }),
      ),
    );
  }
}
