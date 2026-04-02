import 'package:equatable/equatable.dart';

import 'concierge_message.dart';
import 'concierge_top_match.dart';

class ConciergeStepPayload extends Equatable {
  final int stepIndex; 
  final int totalSteps; 
  final String stepMeta; 

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
