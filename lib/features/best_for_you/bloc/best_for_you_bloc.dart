import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/best_for_you_space.dart';
import '../domain/usecases/get_best_for_you_usecase.dart';
import '../domain/usecases/get_top_rated_nearby_usecase.dart';
import 'best_for_you_event.dart';
import 'best_for_you_state.dart';

class BestForYouBloc
    extends Bloc<BestForYouEvent, BestForYouState> {
  final GetBestForYouUseCase getBestForYouUseCase;
  final GetTopRatedNearbyUseCase getTopRatedNearbyUseCase;

  BestForYouBloc({
    required this.getBestForYouUseCase,
    required this.getTopRatedNearbyUseCase,
  }) : super(const BestForYouState()) {
    on<BestForYouStarted>(_onStarted);
    on<BestForYouGoalChanged>(_onGoalChanged);
    on<BestForYouContinuePressed>(_onContinuePressed);
  }

  /// طھط­ظ…ظٹظ„ ط§ظ„ط¨ظٹط§ظ†ط§طھ ظ„ظ„ظ‡ط¯ظپ ط§ظ„ط§ظپطھط±ط§ط¶ظٹ ظˆظ‚ط§ط¦ظ…ط© ط£ط¹ظ„ظ‰ ط§ظ„ظ…ط³ط§ط­ط§طھ ط§ظ„ظ‚ط±ظٹط¨ط©
  Future<void> _onStarted(BestForYouStarted event,
      Emitter<BestForYouState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // ظ†ط­ظ…ظ„ ط§ظ„ظ‚ط§ط¦ظ…ط© ظˆط§ظ„ط£ظپط¶ظ„ ط¨ط§ظ„طھظˆط§ط²ظٹ
      final bestFuture = getBestForYouUseCase(state.selectedGoal);
      final topFuture = getTopRatedNearbyUseCase();

      final bestResult = await bestFuture;
      final List<BestForYouSpace> topList = await topFuture;

      emit(state.copyWith(
        space: bestResult.space,
        fitScore: bestResult.fitScore,
        topSpaces: topList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// طھط­ظ…ظٹظ„ ط§ظ„ط¨ظٹط§ظ†ط§طھ ط¹ظ†ط¯ طھط؛ظٹظٹط± ط§ظ„ظ‡ط¯ظپ
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

  /// ظ…ط¹ط§ظ„ط¬ط© ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ "Continue to Booking"
  void _onContinuePressed(BestForYouContinuePressed event,
      Emitter<BestForYouState> emit) {
    // TODO: navigate to booking page with state.space?.id
  }
}


