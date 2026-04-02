import '../entities/concierge_step_payload.dart';
import '../repos/ai_concierge_repo.dart';

class SubmitAnswerUseCase {
  final AiConciergeRepo repo;

  const SubmitAnswerUseCase(this.repo);

  Future<ConciergeStepPayload> call({required String answer}) {
    return repo.submitUserAnswer(answer: answer);
  }
}