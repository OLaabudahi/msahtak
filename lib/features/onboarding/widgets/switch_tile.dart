import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool withDivider;

  const SwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.withDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              AppSpacing.vXs,
              Text(subtitle, style: AppTextStyles.cardBody),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );

    if (!withDivider) return content;

    return Column(
      children: [
        content,
        AppSpacing.vMd,
        Divider(height: 1, color: AppColors.border.withOpacity(.7)),
      ],
    );
  }
}
