import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class InsightsCard extends StatelessWidget {
  final String title;
  final List<String> chips;

  const InsightsCard({super.key, required this.title, required this.chips});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.softOrange,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          AppSpacing.vMd,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: chips.map((c) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  c,
                  style: AppTextStyles.pillSelected.copyWith(
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
