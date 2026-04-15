import 'package:bloc/bloc.dart';

import '../domain/entities/concierge_message.dart';
import '../domain/usecases/start_concierge_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';
import 'ai_concierge_event.dart';
import 'ai_concierge_state.dart';

class AiConciergeBloc extends Bloc<AiConciergeEvent, AiConciergeState> {
  final StartConciergeUseCase startUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;

  AiConciergeBloc({
    required this.startUseCase,
    required this.submitAnswerUseCase,
  }) : super(AiConciergeState.initial()) {
    on<AiConciergeStarted>(_onStarted);
    on<SendMessage>(_onSendMessage);
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

    try {
      final botReply = await submitAnswerUseCase.call(message: text, lang: event.lang);
      emit(state.copyWith(messages: [...nextMessages, botReply], loading: false, clearError: true));
      add(const ReceiveResponse());
    } catch (_) {
      emit(state.copyWith(loading: false, error: 'reply_failed'));
    }
  }
}
