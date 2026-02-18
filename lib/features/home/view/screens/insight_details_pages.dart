import 'package:flutter/material.dart';
import '../../../../constants/app_assets.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';
import '../../bloc/home_state.dart';

class InsightDetailsPage extends StatelessWidget {
  final InsightItem item;
  const InsightDetailsPage({super.key, required this.item});

  /// ✅ صفحة تفاصيل Insight (Placeholder جاهز)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: AppTextStyles.h1),
              AppSpacing.vMd,
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(item.imageAsset ?? AppAssets.home, height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
              AppSpacing.vMd,
              Text(item.subtitle, style: AppTextStyles.body),
              AppSpacing.vMd,
              const Text('هون بتحط تفاصيل الـ insight من الـ API لاحقاً.', style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
