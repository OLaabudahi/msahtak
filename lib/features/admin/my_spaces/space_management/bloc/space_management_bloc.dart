import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_space_management_usecase.dart';
import '../domain/usecases/set_space_hidden_usecase.dart';
import 'space_management_event.dart';
import 'space_management_state.dart';

class SpaceManagementBloc extends Bloc<SpaceManagementEvent, SpaceManagementState> {
  final GetSpaceManagementUseCase getSpace;
  final SetSpaceHiddenUseCase setHidden;

  SpaceManagementBloc({required this.getSpace, required this.setHidden}) : super(SpaceManagementState.initial()) {
    on<SpaceManagementStarted>(_onStarted);
    on<SpaceManagementHiddenToggled>(_onHidden);
  }

  Future<void> _onStarted(SpaceManagementStarted event, Emitter<SpaceManagementState> emit) async {
    emit(state.copyWith(status: SpaceManagementStatus.loading, error: null));
    try {
      final s = await getSpace(spaceId: event.spaceId);
      emit(state.copyWith(status: SpaceManagementStatus.ready, space: s));
    } catch (e) {
      emit(state.copyWith(status: SpaceManagementStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onHidden(SpaceManagementHiddenToggled event, Emitter<SpaceManagementState> emit) async {
    await setHidden(spaceId: event.spaceId, hidden: event.hidden);
    add(SpaceManagementStarted(event.spaceId));
  }
}


