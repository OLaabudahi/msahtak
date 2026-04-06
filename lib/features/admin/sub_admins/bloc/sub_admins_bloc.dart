import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firestore_api.dart';
import '../domain/usecases/get_admin_spaces_usecase.dart';

import 'sub_admins_event.dart';
import 'sub_admins_state.dart';

class SubAdminsBloc extends Bloc<SubAdminsEvent, SubAdminsState> {
  final GetAdminSpacesUseCase useCase;
  final FirestoreApi api = FirestoreApi();

  SubAdminsBloc(this.useCase) : super(const SubAdminsState()) {
    on<LoadSubAdminsEvent>(_load);
  }

  Future<void> _load(
      LoadSubAdminsEvent event,
      Emitter<SubAdminsState> emit,
      ) async {
    emit(state.copyWith(loading: true));

    try {
      /// spaces
      final spaces = await useCase();

      /// sub admins
      final users = await api.queryWhereEqual(
        collection: 'users',
        field: 'role',
        value: 'sub_admin',
      );

      emit(state.copyWith(
        loading: false,
        spaces: spaces,
        subAdmins: users,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }
}