import 'package:flutter/material.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';

class BookingTabPage extends StatelessWidget {
  const BookingTabPage({super.key});

  /// ✅ دالة: شاشة تبويب Bookings (placeholder)
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bookings', style: AppTextStyles.h1),
          AppSpacing.vSm,
          Text('هون صفحة الحجوزات.', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
