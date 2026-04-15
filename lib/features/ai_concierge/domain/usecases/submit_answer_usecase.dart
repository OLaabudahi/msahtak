import '../entities/concierge_message.dart';
import '../repos/ai_concierge_repo.dart';

class SubmitAnswerUseCase {
  final AiConciergeRepo repo;

  const SubmitAnswerUseCase(this.repo);

  Future<ConciergeMessage> call({
    required String message,
    required String lang,
  }) {
    return repo.sendMessage(message: message, lang: lang);
  }
}
