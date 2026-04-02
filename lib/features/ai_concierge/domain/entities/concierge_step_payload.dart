import 'package:equatable/equatable.dart';

import 'concierge_message.dart';
import 'concierge_top_match.dart';

class ConciergeStepPayload extends Equatable {
  final int stepIndex; // 1..4
  final int totalSteps; // 4
  final String stepMeta; // Step 1 of 4 â€¢ 30 sec

  final List<ConciergeMessage> newMessages;
  final List<String> quickReplies;
  final ConciergeTopMatch? topMatch;
  final bool showContinueButton;

  const ConciergeStepPayload({
    required this.stepIndex,
    required this.totalSteps,
    required this.stepMeta,
    required this.newMessages,
    required this.quickReplies,
    required this.topMatch,
    required this.showContinueButton,
  });

  @override
  List<Object?> get props => [
    stepIndex,
    totalSteps,
    stepMeta,
    newMessages,
    quickReplies,
    topMatch,
    showContinueButton,
  ];
}

