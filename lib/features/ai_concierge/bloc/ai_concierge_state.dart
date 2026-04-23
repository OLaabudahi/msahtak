import 'package:equatable/equatable.dart';

import '../domain/entities/concierge_message.dart';

class AiConciergeState extends Equatable {
  const AiConciergeState({
    required this.messages,
    required this.currentSpaces,
    required this.loading,
    required this.error,
  });

  factory AiConciergeState.initial() => const AiConciergeState(
        messages: [],
        currentSpaces: [],
        loading: false,
        error: null,
      );

  final List<ConciergeMessage> messages;
  final List<Map<String, dynamic>> currentSpaces;
  final bool loading;
  final String? error;

  AiConciergeState copyWith({
    List<ConciergeMessage>? messages,
    List<Map<String, dynamic>>? currentSpaces,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return AiConciergeState(
      messages: messages ?? this.messages,
      currentSpaces: currentSpaces ?? this.currentSpaces,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [messages, currentSpaces, loading, error];
}
