import 'dart:async';

import '../../domain/entities/concierge_message.dart';
import '../../domain/entities/concierge_step_payload.dart';
import '../../domain/entities/concierge_top_match.dart';
import '../../domain/repos/ai_concierge_repo.dart';

class AiConciergeRepoDummy implements AiConciergeRepo {
  int _step = 1;

  String? _purpose;
  String? _duration;

  @override
  Future<ConciergeStepPayload> start() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    _step = 1;
    _purpose = null;
    _duration = null;

    return const ConciergeStepPayload(
      stepIndex: 1,
      totalSteps: 4,
      stepMeta: 'Step 1 of 4 â€¢ 30 sec',
      newMessages: [
        ConciergeMessage(
          id: 'm1',
          sender: ConciergeSender.bot,
          text: 'Hi! What is your purpose?',
        ),
      ],
      quickReplies: ['Study', 'Work', 'Meeting'],
      topMatch: null,
      showContinueButton: false,
    );

    
    
    
  }

  @override
  Future<ConciergeStepPayload> selectQuickReply({required String reply}) async {
    return submitUserAnswer(answer: reply);
  }

  @override
  Future<ConciergeStepPayload> submitUserAnswer({required String answer}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (_step == 1) {
      _purpose = answer;
      _step = 2;

      return ConciergeStepPayload(
        stepIndex: 2,
        totalSteps: 4,
        stepMeta: 'Step 2 of 4 â€¢ 30 sec',
        newMessages: [
          ConciergeMessage(id: 'u1', sender: ConciergeSender.user, text: answer),
          const ConciergeMessage(
            id: 'b2',
            sender: ConciergeSender.bot,
            text: 'Great. How long do you need the space?',
          ),
        ],
        quickReplies: const ['Today', 'Weekly', 'Monthly'],
        topMatch: null,
        showContinueButton: false,
      );
    }

    if (_step == 2) {
      _duration = answer;
      _step = 3;

      return const ConciergeStepPayload(
        stepIndex: 3,
        totalSteps: 4,
        stepMeta: 'Step 3 of 4 â€¢ 30 sec',
        newMessages: [
          ConciergeMessage(id: 'u2', sender: ConciergeSender.user, text: 'Weekly'),
        ],
        quickReplies: [],
        topMatch: ConciergeTopMatch(
          spaceId: 'SPACE-001',
          title: 'Top Match: Space A',
          whyLine: 'Why: very quiet â€¢ strong Wi-Fi â€¢ 10 min away',
          planLine: 'Plan suggestion: Weekly saves you ~18%',
          priceLine: 'Daily â‚ھ10/day â€¢ Weekly â‚ھ58/week',
          imageAsset: 'assets/images/home.png',
          
          
        ),
        showContinueButton: true,
      );
    }

    _step = 4;

    return ConciergeStepPayload(
      stepIndex: 4,
      totalSteps: 4,
      stepMeta: 'Step 4 of 4 â€¢ 30 sec',
      newMessages: const [
        ConciergeMessage(
          id: 'b4',
          sender: ConciergeSender.bot,
          text: 'All set. You can continue to booking.',
        ),
      ],
      quickReplies: const [],
      topMatch: const ConciergeTopMatch(
        spaceId: 'SPACE-001',
        title: 'Top Match: Space A',
        whyLine: 'Why: very quiet â€¢ strong Wi-Fi â€¢ 10 min away',
        planLine: 'Plan suggestion: Weekly saves you ~18%',
        priceLine: 'Daily â‚ھ10/day â€¢ Weekly â‚ھ58/week',
        imageAsset: 'assets/images/home.png',
      ),
      showContinueButton: true,
    );
  }
}
