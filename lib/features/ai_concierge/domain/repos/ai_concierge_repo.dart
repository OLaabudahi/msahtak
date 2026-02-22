import '../entities/concierge_step_payload.dart';

abstract class AiConciergeRepo {
  Future<ConciergeStepPayload> start();

  Future<ConciergeStepPayload> submitUserAnswer({
    required String answer,
  });

  Future<ConciergeStepPayload> selectQuickReply({
    required String reply,
  });
}