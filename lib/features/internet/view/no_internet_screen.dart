import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../core/widgets/app_button.dart';
import '../../../theme/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.t('noInternetTitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.planCardBg,
                  ),
                ),
                AppSpacing.vXl,
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 110,
                  color: AppColors.textSecondary,
                ),
                AppSpacing.vXl,
                AppButton(
                  label: context.t('retry'),
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
