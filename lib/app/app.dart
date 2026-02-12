import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../features/onboarding/view/onboarding_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mashtak',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const OnboardingPage(),
    );
  }
}