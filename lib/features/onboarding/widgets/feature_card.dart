import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String body;

  const FeatureCard({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.cardTitle),
            AppSpacing.vXs,
            Text(body, style: AppTextStyles.cardBody),
          ],
        ),
      ),
    );
  }
}