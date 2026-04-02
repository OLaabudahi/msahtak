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

  /// تحميل المساحات والخطة الافتراضية
  Future<void> _onStarted(
      WeeklyPlanStarted event, Emitter<WeeklyPlanState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getWeeklyPlanUseCase(state.selectedHubId);
      final hubs = result.hubs;
      // إذا كان الـ selectedHubId الافتراضي غير موجود في القائمة نستخدم أول عنصر
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

  /// تحميل تفاصيل الخطة عند تغيير المساحة
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

  /// تفعيل الخطة الأسبوعية
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
