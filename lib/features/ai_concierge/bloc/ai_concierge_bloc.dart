import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/concierge_message.dart';
import '../domain/usecases/finalize_concierge_session_usecase.dart';
import '../domain/usecases/start_concierge_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';
import 'ai_concierge_event.dart';
import 'ai_concierge_state.dart';

class AiConciergeBloc extends Bloc<AiConciergeEvent, AiConciergeState> {
  final StartConciergeUseCase startUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;
  final FinalizeConciergeSessionUseCase finalizeConciergeSessionUseCase;

  AiConciergeBloc({
    required this.startUseCase,
    required this.submitAnswerUseCase,
    required this.finalizeConciergeSessionUseCase,
  }) : super(AiConciergeState.initial()) {
    on<AiConciergeStarted>(_onStarted);
    on<SendMessage>(_onSendMessage);
    on<FinalizeSessionRequested>(_onFinalizeSessionRequested);
    on<ReceiveResponse>((event, emit) {});
  }

  Future<void> _onStarted(
    AiConciergeStarted event,
    Emitter<AiConciergeState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final greeting = await startUseCase.call(lang: event.lang);
      emit(state.copyWith(messages: [greeting], loading: false, clearError: true));
    } catch (_) {
      emit(state.copyWith(loading: false, error: 'start_failed'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<AiConciergeState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty) return;

    final userMessage = ConciergeMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sender: ConciergeSender.user,
      text: text,
    );

    final nextMessages = [...state.messages, userMessage];
    emit(state.copyWith(messages: nextMessages, loading: true, clearError: true));

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final history = _buildHistory(nextMessages);
    final lastSpaces = state.currentSpaces
        .map((space) => _extractSpaceId(space))
        .where((id) => id.isNotEmpty)
        .toList();

    try {
      final reply = await submitAnswerUseCase.call(
        message: text,
        userId: userId,
        history: history,
        lastSpaces: lastSpaces,
      );
      emit(state.copyWith(
        messages: [...nextMessages, reply.message],
        currentSpaces: reply.currentSpaces,
        loading: false,
        clearError: true,
      ));
      add(const ReceiveResponse());
    } catch (_) {
      emit(state.copyWith(loading: false, error: 'reply_failed'));
    }
  }

  Future<void> _onFinalizeSessionRequested(
    FinalizeSessionRequested event,
    Emitter<AiConciergeState> emit,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final history = _buildHistory(state.messages);
    if (userId.isEmpty || history.isEmpty) return;

    await finalizeConciergeSessionUseCase.call(userId: userId, history: history);
  }

  List<Map<String, dynamic>> _buildHistory(List<ConciergeMessage> messages) {
    final nonEmpty = messages.where((m) => m.text.trim().isNotEmpty).toList();
    final firstUserIndex = nonEmpty.indexWhere((m) => m.sender == ConciergeSender.user);

    if (firstUserIndex < 0) return const [];

    return nonEmpty
        .skip(firstUserIndex)
        .map(
          (m) => {
            'role': m.sender == ConciergeSender.user ? 'user' : 'model',
            'parts': [
              {'text': m.text.trim()}
            ],
          },
        )
        .toList();
  }

  String _extractSpaceId(Map<String, dynamic> space) {
    final id = space['id'] ?? space['spaceId'] ?? space['_id'] ?? '';
    return id.toString();
  }
}
