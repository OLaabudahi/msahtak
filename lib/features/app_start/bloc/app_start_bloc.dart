import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repos/app_start_repo.dart';
import 'app_start_event.dart';
import 'app_start_state.dart';

class AppStartBloc extends Bloc<AppStartEvent, AppStartState> {
  AppStartBloc(this._repo)
    : super(const AppStartState(loading: true, decision: null)) {
    on<AppStartStarted>(_onStarted);
  }

  final AppStartRepo _repo;

  Future<void> _onStarted(
    AppStartStarted event,
    Emitter<AppStartState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, decision: null));
      final decision = await _repo.decide();
      emit(state.copyWith(loading: false, decision: decision, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}


