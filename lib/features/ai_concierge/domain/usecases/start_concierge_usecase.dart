import '../entities/concierge_message.dart';
import '../repos/ai_concierge_repo.dart';

class StartConciergeUseCase {
  final AiConciergeRepo repo;

  const StartConciergeUseCase(this.repo);

  Future<ConciergeMessage> call({required String lang}) {
    return repo.createGreeting(lang: lang);
  }
}
