import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/apply_plan_usecase.dart';
import '../domain/usecases/get_usage_usecase.dart';
import 'usage_event.dart';
import 'usage_state.dart';

class UsageBloc extends Bloc<UsageEvent, UsageState> {
  final GetUsageUseCase getUsageUseCase;
  final ApplyPlanUseCase applyPlanUseCase;

  UsageBloc({
    required this.getUsageUseCase,
    required this.applyPlanUseCase,
  }) : super(const UsageState()) {
    on<UsageStarted>(_onStarted);
    on<UsagePlanSelected>(_onPlanSelected);
    on<UsagePlanApplied>(_onPlanApplied);
  }

  
  Future<void> _onStarted(
      UsageStarted event, Emitter<UsageState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getUsageUseCase();
      
      final bestIndex =
          result.plans.indexWhere((p) => p.isBest);
      emit(state.copyWith(
          stats: result.stats,
          plans: result.plans,
          selectedPlanIndex: bestIndex >= 0 ? bestIndex : 1,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  
  void _onPlanSelected(
      UsagePlanSelected event, Emitter<UsageState> emit) {
    emit(state.copyWith(
        selectedPlanIndex: event.index, isApplied: false));
  }

  
  Future<void> _onPlanApplied(
      UsagePlanApplied event, Emitter<UsageState> emit) async {
    if (state.plans.isEmpty) return;
    emit(state.copyWith(isApplying: true));
    try {
      final planId =
          state.plans[state.selectedPlanIndex].id;
      await applyPlanUseCase(planId);
      emit(state.copyWith(isApplying: false, isApplied: true));
    } catch (e) {
      emit(state.copyWith(isApplying: false, error: e.toString()));
    }
  }
}
