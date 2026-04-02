import '../entities/concierge_step_payload.dart';
import '../repos/ai_concierge_repo.dart';

class SelectQuickReplyUseCase {
  final AiConciergeRepo repo;

  const SelectQuickReplyUseCase(this.repo);

  Future<ConciergeStepPayload> call({required String reply}) {
    return repo.selectQuickReply(reply: reply);
  }
}