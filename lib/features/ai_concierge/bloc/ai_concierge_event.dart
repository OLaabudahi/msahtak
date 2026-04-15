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
  const SendMessage({required this.message, required this.lang});

  final String message;
  final String lang;

  @override
  List<Object?> get props => [message, lang];
}

class ReceiveResponse extends AiConciergeEvent {
  const ReceiveResponse();
}
