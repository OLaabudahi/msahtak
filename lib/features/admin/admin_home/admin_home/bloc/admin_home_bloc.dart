import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_admin_home_kpis_usecase.dart';
import '../domain/usecases/get_admin_spaces_usecase.dart';
import 'admin_home_event.dart';
import 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetAdminSpacesUseCase getSpaces;
  final GetAdminHomeKpisUseCase getKpis;

  AdminHomeBloc({required this.getSpaces, required this.getKpis}) : super(AdminHomeState.initial()) {
    on<AdminHomeStarted>(_onStarted);
    on<AdminHomeSpaceChanged>(_onSpaceChanged);
  }

  Future<void> _onStarted(AdminHomeStarted event, Emitter<AdminHomeState> emit) async {
    emit(state.copyWith(status: AdminHomeStatus.loading, error: null));
    try {
      final spaces = await getSpaces();
      final active = spaces.isNotEmpty ? spaces.first : '';
      // final kpis = active.isEmpty ? const [] : await getKpis(spaceId: active);
      emit(state.copyWith(status: AdminHomeStatus.success, spaces: spaces, activeSpace: active, kpis:  active.isEmpty ? const [] : await getKpis(spaceId: active)));
    } catch (e) {
      emit(state.copyWith(status: AdminHomeStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSpaceChanged(AdminHomeSpaceChanged event, Emitter<AdminHomeState> emit) async {
    emit(state.copyWith(status: AdminHomeStatus.loading, activeSpace: event.spaceId, error: null));
    try {
      final kpis = await getKpis(spaceId: event.spaceId);
      emit(state.copyWith(status: AdminHomeStatus.success, kpis: kpis));
    } catch (e) {
      emit(state.copyWith(status: AdminHomeStatus.failure, error: e.toString()));
    }
  }
}
