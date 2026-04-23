import '../repos/ai_concierge_repo.dart';

class FinalizeConciergeSessionUseCase {
  const FinalizeConciergeSessionUseCase(this.repo);

  final AiConciergeRepo repo;

  Future<void> call({
    required String userId,
    required List<Map<String, dynamic>> history,
  }) {
    return repo.finalizeSession(userId: userId, history: history);
  }
}
