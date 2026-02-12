import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home Screen', style: AppTextStyles.h1),
              AppSpacing.vSm,
              Text('Onboarding finished ✅', style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}