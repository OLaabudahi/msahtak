import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/submit_space_request_usecase.dart';
import 'space_request_event.dart';
import 'space_request_state.dart';

class SpaceRequestBloc extends Bloc<SpaceRequestEvent, SpaceRequestState> {
  final SubmitSpaceRequestUseCase submitSpaceRequestUseCase;

  SpaceRequestBloc(this.submitSpaceRequestUseCase)
      : super(const SpaceRequestInitial()) {
    on<ResetSpaceRequestEvent>((event, emit) {
      emit(const SpaceRequestInitial());
    });

    on<SubmitSpaceRequestEvent>((event, emit) async {
      emit(const SpaceRequestLoading());

      try {
        await submitSpaceRequestUseCase(event.request);
        emit(const SpaceRequestSuccess());
      } catch (error) {
        emit(SpaceRequestError(error.toString()));
      }
    });
  }
}
