import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class PlaceholderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const PlaceholderCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h2),
                  AppSpacing.vSm,
                  Text(subtitle, style: AppTextStyles.bodyMuted),
                ],
              ),
            ),
            if (trailing != null) ...[
              AppSpacing.hLg,
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
