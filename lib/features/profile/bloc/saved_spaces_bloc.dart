import 'package:bloc/bloc.dart';

import '../domain/usecases/get_saved_spaces_usecase.dart';
import 'saved_spaces_event.dart';
import 'saved_spaces_state.dart';

class SavedSpacesBloc extends Bloc<SavedSpacesEvent, SavedSpacesState> {
  final GetSavedSpacesUseCase getSavedSpacesUseCase;

  SavedSpacesBloc({
    required this.getSavedSpacesUseCase,
  }) : super(SavedSpacesState.initial()) {
    on<SavedSpacesStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SavedSpacesStarted event,
    Emitter<SavedSpacesState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final spaces = await getSavedSpacesUseCase.call();
      emit(state.copyWith(loading: false, error: null, spaces: spaces));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
