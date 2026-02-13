import 'package:flutter/material.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  /// ✅ دالة: شاشة تبويب Profile (placeholder)
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text('هون صفحة البروفايل.', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
