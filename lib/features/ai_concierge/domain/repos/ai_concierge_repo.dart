import '../entities/concierge_message.dart';
import '../entities/concierge_reply.dart';

abstract class AiConciergeRepo {
  Future<ConciergeMessage> createGreeting({required String lang});

  Future<ConciergeReply> sendMessage({
    required String message,
    required String userId,
    required List<Map<String, dynamic>> history,
    required List<String> lastSpaces,
  });

  Future<void> finalizeSession({
    required String userId,
    required List<Map<String, dynamic>> history,
  });
}
