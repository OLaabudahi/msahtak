import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repos/app_start_repo.dart';
import '../domain/usecases/decide_app_start_usecase.dart';
import '../domain/usecases/initialize_startup_usecase.dart';
import 'app_start_event.dart';
import 'app_start_state.dart';

class AppStartBloc extends Bloc<AppStartEvent, AppStartState> {
  AppStartBloc(
    this._repo, {
    required InitializeStartupUseCase initializeStartupUseCase,
  }) : _initializeStartupUseCase = initializeStartupUseCase,
       _decideAppStartUseCase = DecideAppStartUseCase(_repo),
       super(const AppStartState(loading: true, decision: null)) {
    on<AppStartStarted>(_onStarted);
  }

  final AppStartRepo _repo;
  final InitializeStartupUseCase _initializeStartupUseCase;
  final DecideAppStartUseCase _decideAppStartUseCase;

  Future<void> _onStarted(
    AppStartStarted event,
    Emitter<AppStartState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, decision: null));
      await _initializeStartupUseCase();
      final decision = await _decideAppStartUseCase();
      emit(state.copyWith(loading: false, decision: decision, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
