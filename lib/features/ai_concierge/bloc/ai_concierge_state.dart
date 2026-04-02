import 'package:equatable/equatable.dart';

import '../domain/entities/concierge_message.dart';
import '../domain/entities/concierge_top_match.dart';

enum AiConciergeStatus { initial, loading, ready, failure }

class AiConciergeState extends Equatable {
  final AiConciergeStatus status;
  final String? errorMessage;

  final int stepIndex;
  final int totalSteps;
  final String stepMeta;

  final List<ConciergeMessage> messages;
  final List<String> quickReplies;
  final ConciergeTopMatch? topMatch;
  final bool showContinueButton;

  const AiConciergeState({
    required this.status,
    required this.errorMessage,
    required this.stepIndex,
    required this.totalSteps,
    required this.stepMeta,
    required this.messages,
    required this.quickReplies,
    required this.topMatch,
    required this.showContinueButton,
  });

  factory AiConciergeState.initial() => const AiConciergeState(
    status: AiConciergeStatus.initial,
    errorMessage: null,
    stepIndex: 1,
    totalSteps: 4,
    stepMeta: 'Step 1 of 4 â€¢ 30 sec',
    messages: [],
    quickReplies: [],
    topMatch: null,
    showContinueButton: false,
  );

  AiConciergeState copyWith({
    AiConciergeStatus? status,
    String? errorMessage,
    int? stepIndex,
    int? totalSteps,
    String? stepMeta,
    List<ConciergeMessage>? messages,
    List<String>? quickReplies,
    ConciergeTopMatch? topMatch,
    bool? showContinueButton,
    bool clearError = false,
  }) {
    return AiConciergeState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      stepIndex: stepIndex ?? this.stepIndex,
      totalSteps: totalSteps ?? this.totalSteps,
      stepMeta: stepMeta ?? this.stepMeta,
      messages: messages ?? this.messages,
      quickReplies: quickReplies ?? this.quickReplies,
      topMatch: topMatch ?? this.topMatch,
      showContinueButton: showContinueButton ?? this.showContinueButton,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    stepIndex,
    totalSteps,
    stepMeta,
    messages,
    quickReplies,
    topMatch,
    showContinueButton,
  ];
}
