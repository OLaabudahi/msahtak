import 'package:bloc/bloc.dart';

import '../domain/usecases/select_quick_reply_usecase.dart';
import '../domain/usecases/start_concierge_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';
import 'ai_concierge_event.dart';
import 'ai_concierge_state.dart';

class AiConciergeBloc extends Bloc<AiConciergeEvent, AiConciergeState> {
  final StartConciergeUseCase startUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;
  final SelectQuickReplyUseCase selectQuickReplyUseCase;

  AiConciergeBloc({
    required this.startUseCase,
    required this.submitAnswerUseCase,
    required this.selectQuickReplyUseCase,
  }) : super(AiConciergeState.initial()) {
    on<AiConciergeStarted>(_onStarted);
    on<AiConciergeUserTextSent>(_onUserText);
    on<AiConciergeQuickReplySelected>(_onQuickReply);
    on<AiConciergeResetRequested>(_onReset);
  }

  Future<void> _onStarted(AiConciergeStarted event, Emitter<AiConciergeState> emit) async {
    emit(state.copyWith(status: AiConciergeStatus.loading, clearError: true));
    try {
      final payload = await startUseCase.call();
      emit(
        state.copyWith(
          status: AiConciergeStatus.ready,
          stepIndex: payload.stepIndex,
          totalSteps: payload.totalSteps,
          stepMeta: payload.stepMeta,
          messages: payload.newMessages,
          quickReplies: payload.quickReplies,
          topMatch: payload.topMatch,
          showContinueButton: payload.showContinueButton,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AiConciergeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onQuickReply(AiConciergeQuickReplySelected event, Emitter<AiConciergeState> emit) async {
    emit(state.copyWith(status: AiConciergeStatus.loading, clearError: true));
    try {
      final payload = await selectQuickReplyUseCase.call(reply: event.reply);
      emit(
        state.copyWith(
          status: AiConciergeStatus.ready,
          stepIndex: payload.stepIndex,
          totalSteps: payload.totalSteps,
          stepMeta: payload.stepMeta,
          messages: [...state.messages, ...payload.newMessages],
          quickReplies: payload.quickReplies,
          topMatch: payload.topMatch,
          showContinueButton: payload.showContinueButton,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AiConciergeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUserText(AiConciergeUserTextSent event, Emitter<AiConciergeState> emit) async {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final matched = state.quickReplies.firstWhere(
          (r) => r.toLowerCase() == text.toLowerCase(),
      orElse: () => '',
    );

    final answer = matched.isNotEmpty ? matched : text;

    emit(state.copyWith(status: AiConciergeStatus.loading, clearError: true));
    try {
      final payload = await submitAnswerUseCase.call(answer: answer);
      emit(
        state.copyWith(
          status: AiConciergeStatus.ready,
          stepIndex: payload.stepIndex,
          totalSteps: payload.totalSteps,
          stepMeta: payload.stepMeta,
          messages: [...state.messages, ...payload.newMessages],
          quickReplies: payload.quickReplies,
          topMatch: payload.topMatch,
          showContinueButton: payload.showContinueButton,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AiConciergeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onReset(AiConciergeResetRequested event, Emitter<AiConciergeState> emit) async {
    add(const AiConciergeStarted());
  }
}
