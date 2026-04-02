import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/activate_plan_usecase.dart';
import '../domain/usecases/get_weekly_plan_usecase.dart';
import 'weekly_plan_event.dart';
import 'weekly_plan_state.dart';

class WeeklyPlanBloc extends Bloc<WeeklyPlanEvent, WeeklyPlanState> {
  final GetWeeklyPlanUseCase getWeeklyPlanUseCase;
  final ActivatePlanUseCase activatePlanUseCase;

  WeeklyPlanBloc({
    required this.getWeeklyPlanUseCase,
    required this.activatePlanUseCase,
  }) : super(const WeeklyPlanState()) {
    on<WeeklyPlanStarted>(_onStarted);
    on<WeeklyPlanHubChanged>(_onHubChanged);
    on<WeeklyPlanActivatePressed>(_onActivatePressed);
  }

  /// طھط­ظ…ظٹظ„ ط§ظ„ظ…ط³ط§ط­ط§طھ ظˆط§ظ„ط®ط·ط© ط§ظ„ط§ظپطھط±ط§ط¶ظٹط©
  Future<void> _onStarted(
      WeeklyPlanStarted event, Emitter<WeeklyPlanState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getWeeklyPlanUseCase(state.selectedHubId);
      final hubs = result.hubs;
      // ط¥ط°ط§ ظƒط§ظ† ط§ظ„ظ€ selectedHubId ط§ظ„ط§ظپطھط±ط§ط¶ظٹ ط؛ظٹط± ظ…ظˆط¬ظˆط¯ ظپظٹ ط§ظ„ظ‚ط§ط¦ظ…ط© ظ†ط³طھط®ط¯ظ… ط£ظˆظ„ ط¹ظ†طµط±
      final resolvedId = hubs.isNotEmpty &&
              !hubs.any((h) => h.id == state.selectedHubId)
          ? hubs.first.id
          : state.selectedHubId;
      final details = resolvedId != state.selectedHubId
          ? (await getWeeklyPlanUseCase(resolvedId)).details
          : result.details;
      emit(state.copyWith(
          hubs: hubs,
          selectedHubId: resolvedId,
          planDetails: details,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// طھط­ظ…ظٹظ„ طھظپط§طµظٹظ„ ط§ظ„ط®ط·ط© ط¹ظ†ط¯ طھط؛ظٹظٹط± ط§ظ„ظ…ط³ط§ط­ط©
  Future<void> _onHubChanged(
      WeeklyPlanHubChanged event, Emitter<WeeklyPlanState> emit) async {
    emit(state.copyWith(selectedHubId: event.hubId, isLoading: true));
    try {
      final result = await getWeeklyPlanUseCase(event.hubId);
      emit(state.copyWith(
          planDetails: result.details, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// طھظپط¹ظٹظ„ ط§ظ„ط®ط·ط© ط§ظ„ط£ط³ط¨ظˆط¹ظٹط©
  Future<void> _onActivatePressed(WeeklyPlanActivatePressed event,
      Emitter<WeeklyPlanState> emit) async {
    emit(state.copyWith(isActivating: true));
    try {
      await activatePlanUseCase(state.selectedHubId);
      emit(state.copyWith(isActivating: false, isActivated: true));
    } catch (e) {
      emit(state.copyWith(isActivating: false, error: e.toString()));
    }
  }
}


