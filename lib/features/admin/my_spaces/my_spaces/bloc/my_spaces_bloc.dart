import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_my_spaces_usecase.dart';
import '../domain/usecases/hide_space_usecase.dart';
import 'my_spaces_event.dart';
import 'my_spaces_state.dart';

class MySpacesBloc extends Bloc<MySpacesEvent, MySpacesState> {
  final GetMySpacesUseCase getSpaces;
  final HideSpaceUseCase hideSpace;

  MySpacesBloc({required this.getSpaces, required this.hideSpace}) : super(MySpacesState.initial()) {
    on<MySpacesStarted>(_onStarted);
    on<MySpacesHidePressed>(_onHide);
  }

  Future<void> _onStarted(MySpacesStarted event, Emitter<MySpacesState> emit) async {
    emit(state.copyWith(status: MySpacesStatus.loading, error: null));
    try {
      final list = await getSpaces();
      emit(state.copyWith(status: MySpacesStatus.success, spaces: list));
    } catch (e) {
      emit(state.copyWith(status: MySpacesStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onHide(MySpacesHidePressed event, Emitter<MySpacesState> emit) async {
    await hideSpace(spaceId: event.spaceId);
    add(const MySpacesStarted());
  }
}
