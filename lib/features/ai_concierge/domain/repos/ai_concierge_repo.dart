import '../entities/concierge_message.dart';

abstract class AiConciergeRepo {
  Future<ConciergeMessage> createGreeting({required String lang});

  Future<ConciergeMessage> sendMessage({
    required String message,
    required String lang,
  });
}
