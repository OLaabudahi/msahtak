import '../entities/concierge_step_payload.dart';
import '../repos/ai_concierge_repo.dart';

class StartConciergeUseCase {
  final AiConciergeRepo repo;

  const StartConciergeUseCase(this.repo);

  Future<ConciergeStepPayload> call() {
    return repo.start();
  }
}