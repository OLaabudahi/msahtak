import 'package:equatable/equatable.dart';

sealed class AiConciergeEvent extends Equatable {
  const AiConciergeEvent();
  @override
  List<Object?> get props => [];
}

class AiConciergeStarted extends AiConciergeEvent {
  const AiConciergeStarted();
}

class AiConciergeUserTextSent extends AiConciergeEvent {
  final String text;
  const AiConciergeUserTextSent(this.text);

  @override
  List<Object?> get props => [text];
}

class AiConciergeQuickReplySelected extends AiConciergeEvent {
  final String reply;
  const AiConciergeQuickReplySelected(this.reply);

  @override
  List<Object?> get props => [reply];
}

class AiConciergeResetRequested extends AiConciergeEvent {
  const AiConciergeResetRequested();
}