import 'package:equatable/equatable.dart';

import '../domain/entities/concierge_message.dart';

class AiConciergeState extends Equatable {
  const AiConciergeState({
    required this.messages,
    required this.loading,
    required this.error,
  });

  factory AiConciergeState.initial() => const AiConciergeState(
    messages: [],
    loading: false,
    error: null,
  );

  final List<ConciergeMessage> messages;
  final bool loading;
  final String? error;

  AiConciergeState copyWith({
    List<ConciergeMessage>? messages,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return AiConciergeState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [messages, loading, error];
}
