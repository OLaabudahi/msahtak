import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/language_service.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc(this._service)
    : super(const LanguageState(loading: true, code: 'en')) {
    on<LanguageStarted>(_onStarted);
    on<LanguageChanged>(_onChanged);
  }

  final LanguageService _service;

  Future<void> _onStarted(
    LanguageStarted event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null));
      final lang = await _service.loadLanguage();
      emit(state.copyWith(loading: false, code: lang.code, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null));
      await _service.setLanguage(event.code);
      emit(state.copyWith(loading: false, code: event.code, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}


