abstract class AppStartRepo {
  Future<AppStartDecision> decide();
}

enum AppStartDecision { goLogin, goOnboarding, goHome, goAdmin }
