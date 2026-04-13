import '../../../../core/services/startup/app_initializer_service.dart';

class InitializeStartupUseCase {
  final AppInitializerService service;

  const InitializeStartupUseCase(this.service);

  Future<void> call() {
    return service.initialize();
  }
}
