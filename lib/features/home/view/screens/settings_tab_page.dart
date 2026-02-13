import 'package:flutter/material.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';

class SettingsTabPage extends StatelessWidget {
  const SettingsTabPage({super.key});

  /// ✅ دالة: شاشة تبويب Settings (placeholder)
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text('هون صفحة الإعدادات.', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
