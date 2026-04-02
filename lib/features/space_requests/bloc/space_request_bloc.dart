import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/space_request_entity.dart';
import '../domain/usecases/submit_space_request_usecase.dart';
import 'space_request_event.dart';
import 'space_request_state.dart';

class SpaceRequestBloc extends Bloc<SpaceRequestEvent, SpaceRequestState> {
  final SubmitSpaceRequestUseCase useCase;

  SpaceRequestBloc(this.useCase) : super(SpaceRequestInitial()) {
    on<ResetSpaceRequestEvent>((event, emit) {
      emit(SpaceRequestInitial());
    });
    on<SubmitSpaceRequestEvent>((event, emit) async {
      emit(SpaceRequestLoading());

      try {
        final entity = SpaceRequestEntity(
          idRequest: event.data["idRequest"],
          nameSpace: event.data["nameSpace"],
          descriptionSpace: event.data["descriptionSpace"],
          locationDes: event.data["locationDes"],
          phoneNo: event.data["phoneNo"],
          whatsAppNo: event.data["whatsAppNo"],
          contactName: event.data["contactName"],
          pricePerDay: event.data["pricePerDay"],
          capacity: event.data["capacity"],
          workingHours: event.data["workingHours"],
          createdAt: event.data["createdAt"],
        );

        await useCase(entity);

        emit(SpaceRequestSuccess());
      } catch (e) {
        emit(SpaceRequestError(e.toString()));
      }
    });
  }
}

