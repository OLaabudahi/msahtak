import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class InfoBanner extends StatelessWidget {
  final IconData? leadingIcon;
  final String? iconText;
  final String title;
  final String subtitle;
  final String footnote;

  const InfoBanner({
    super.key,
    this.leadingIcon,
    this.iconText,
    required this.title,
    required this.subtitle,
    required this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBadge(leadingIcon: leadingIcon, iconText: iconText),
        AppSpacing.hMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              AppSpacing.vXs,
              Text(subtitle, style: AppTextStyles.cardBody),
              AppSpacing.vSm,
              Text(
                footnote,
                style: AppTextStyles.caption.copyWith(color: AppColors.hint),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData? leadingIcon;
  final String? iconText;

  const _IconBadge({this.leadingIcon, this.iconText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: leadingIcon != null
          ? Icon(leadingIcon, color: AppColors.primary, size: 24)
          : Text(
        iconText ?? '',
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900),
      ),
    );
  }
}