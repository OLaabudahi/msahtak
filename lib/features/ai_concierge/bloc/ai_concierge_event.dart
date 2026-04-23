import 'package:equatable/equatable.dart';

sealed class AiConciergeEvent extends Equatable {
  const AiConciergeEvent();

  @override
  List<Object?> get props => [];
}

class AiConciergeStarted extends AiConciergeEvent {
  const AiConciergeStarted({required this.lang});

  final String lang;

  @override
  List<Object?> get props => [lang];
}

class SendMessage extends AiConciergeEvent {
  const SendMessage({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ReceiveResponse extends AiConciergeEvent {
  const ReceiveResponse();
}

class FinalizeSessionRequested extends AiConciergeEvent {
  const FinalizeSessionRequested();
}
