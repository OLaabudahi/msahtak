import '../entities/concierge_reply.dart';
import '../repos/ai_concierge_repo.dart';

class SubmitAnswerUseCase {
  final AiConciergeRepo repo;

  const SubmitAnswerUseCase(this.repo);

  Future<ConciergeReply> call({
    required String message,
    required String userId,
    required List<Map<String, dynamic>> history,
    required List<String> lastSpaces,
  }) {
    return repo.sendMessage(
      message: message,
      userId: userId,
      history: history,
      lastSpaces: lastSpaces,
    );
  }
}
