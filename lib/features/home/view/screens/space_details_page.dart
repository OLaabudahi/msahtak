import 'package:flutter/material.dart';
import '../../../../constants/app_assets.dart';
import '../../../../constants/app_spacing.dart';
import '../../../../theme/app_text_styles.dart';

class SpaceDetailsPage extends StatelessWidget {
  final String spaceId;
  const SpaceDetailsPage({super.key, required this.spaceId});

  /// ✅ صفحة تفاصيل المساحة (Placeholder جاهز)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Space Details')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Space: $spaceId', style: AppTextStyles.h1),
              AppSpacing.vMd,
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(AppAssets.home, height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
              AppSpacing.vMd,
              const Text('هون تفاصيل المساحة (لما يجهز الـ API بنعبيها).', style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
