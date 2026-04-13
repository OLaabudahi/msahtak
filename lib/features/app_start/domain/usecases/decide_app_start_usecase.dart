import '../repos/app_start_repo.dart';

class DecideAppStartUseCase {
  final AppStartRepo repo;

  const DecideAppStartUseCase(this.repo);

  Future<AppStartDecision> call() {
    return repo.decide();
  }
}
