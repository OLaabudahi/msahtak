import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/app_start/view/splash_page.dart';
import '../features/admin/navigation/admin_root/view/admin_root_page.dart';
import '../features/app_start/bloc/app_start_bloc.dart';
import '../features/app_start/bloc/app_start_event.dart';
import '../features/app_start/bloc/app_start_state.dart';
import '../features/app_start/domain/repos/app_start_repo.dart';
import '../features/app_start/data/repos/app_start_repo_firebase.dart';
import '../features/auth/view/login_page.dart';
import '../features/home/view/home_page.dart';
import '../features/onboarding/view/onboarding_page.dart';
import '../services/local_storage_service.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  static Widget withBloc() {
    final storage = LocalStorageService();
    return BlocProvider(
      create: (_) =>
          AppStartBloc(AppStartRepoFirebase(storage))
            ..add(const AppStartStarted()),
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

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => OnboardingPage.withBloc()));

    // When onboarding finishes (page popped), mark completed then re-check flow.
    await LocalStorageService().setHasCompletedOnboarding(true);

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
          // Splash while deciding
          if (state.loading || state.decision == null) {
            return const SplashPage();
          }

          // Flow (same as your logic):
          // - not logged in => Login
          // - logged in + not onboarding => open onboarding (listener) and keep splash behind
          // - logged in + onboarding done => Home
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
