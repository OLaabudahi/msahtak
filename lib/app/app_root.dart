import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/app_injector.dart';
import '../features/app_start/domain/repos/app_start_repo.dart';
import '../features/app_start/view/splash_page.dart';
import '../features/admin/navigation/admin_root/view/admin_root_page.dart';
import '../features/app_start/bloc/app_start_bloc.dart';
import '../features/app_start/bloc/app_start_event.dart';
import '../features/app_start/bloc/app_start_state.dart';
import '../features/auth/view/login_page.dart';
import '../features/home/view/home_page.dart';
import '../features/onboarding/view/onboarding_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  static Widget withBloc() {
    return BlocProvider(
      create: (_) => getIt<AppStartBloc>()..add(const AppStartStarted()),
      child: const AppRoot(),
    );
  }

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _openingOnboarding = false;

  Future<void> _openOnboarding(BuildContext context) async {
    if (_openingOnboarding) return;
    _openingOnboarding = true;

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => OnboardingPage.withBloc()),
    );

    if (mounted) {
      context.read<AppStartBloc>().add(const AppStartStarted());
    }

    _openingOnboarding = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartBloc, AppStartState>(
      listenWhen: (p, c) => p.decision != c.decision && c.decision != null,
      listener: (context, state) async {
        if (state.decision == AppStartDecision.goOnboarding) {
          await _openOnboarding(context);
        }
      },
      child: BlocBuilder<AppStartBloc, AppStartState>(
        builder: (context, state) {

          if (state.loading || state.decision == null) {
            return const SplashPage();
          }
          switch (state.decision!) {
            case AppStartDecision.goLogin:
              return const LoginPage();

            case AppStartDecision.goOnboarding:
              return const SplashPage();

            case AppStartDecision.goHome:
              return HomePage.withBloc();

            case AppStartDecision.goAdmin:
              return AdminRootPage.withBloc();
          }
        },
      ),
    );
  }
}
