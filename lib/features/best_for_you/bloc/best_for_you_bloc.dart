import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_best_for_you_usecase.dart';
import 'best_for_you_event.dart';
import 'best_for_you_state.dart';

class BestForYouBloc
    extends Bloc<BestForYouEvent, BestForYouState> {
  final GetBestForYouUseCase getBestForYouUseCase;

  BestForYouBloc({required this.getBestForYouUseCase})
      : super(const BestForYouState()) {
    on<BestForYouStarted>(_onStarted);
    on<BestForYouGoalChanged>(_onGoalChanged);
    on<BestForYouContinuePressed>(_onContinuePressed);
  }

  /// تحميل البيانات للهدف الافتراضي
  Future<void> _onStarted(BestForYouStarted event,
      Emitter<BestForYouState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result =
          await getBestForYouUseCase(state.selectedGoal);
      emit(state.copyWith(
          space: result.space,
          fitScore: result.fitScore,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// تحميل البيانات عند تغيير الهدف
  Future<void> _onGoalChanged(BestForYouGoalChanged event,
      Emitter<BestForYouState> emit) async {
    emit(state.copyWith(selectedGoal: event.goal, isLoading: true));
    try {
      final result = await getBestForYouUseCase(event.goal);
      emit(state.copyWith(
          space: result.space,
          fitScore: result.fitScore,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// معالجة الضغط على "Continue to Booking"
  void _onContinuePressed(BestForYouContinuePressed event,
      Emitter<BestForYouState> emit) {
    // TODO: navigate to booking page with state.space?.id
  }
}
