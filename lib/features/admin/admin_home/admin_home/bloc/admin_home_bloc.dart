import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/kpi_entity.dart';
import '../domain/entities/admin_space_item.dart';
import '../domain/entities/admin_activity_item.dart';
import '../domain/usecases/get_admin_home_kpis_usecase.dart';
import '../domain/usecases/get_admin_spaces_usecase.dart';
import '../domain/usecases/get_admin_recent_activity_usecase.dart';
import 'admin_home_event.dart';
import 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetAdminSpacesUseCase getSpaces;
  final GetAdminHomeKpisUseCase getKpis;
  final GetAdminRecentActivityUseCase getActivity;

  AdminHomeBloc({
    required this.getSpaces,
    required this.getKpis,
    required this.getActivity,
  }) : super(AdminHomeState.initial()) {
    on<AdminHomeStarted>(_onStarted);
    on<AdminHomeSpaceChanged>(_onSpaceChanged);
  }

  Future<void> _onStarted(AdminHomeStarted event, Emitter<AdminHomeState> emit) async {
    emit(state.copyWith(status: AdminHomeStatus.loading, error: null));
    try {
      final List<AdminSpaceItem> spaces = await getSpaces();
      final List<AdminActivityItem> activity = await getActivity();
      final firstId = spaces.isNotEmpty ? spaces.first.id : '';
      final firstName = spaces.isNotEmpty ? spaces.first.name : '';
      final List<KpiEntity> kpis = firstId.isEmpty ? const [] : await getKpis(spaceId: firstId);
      emit(state.copyWith(
        status: AdminHomeStatus.success,
        spaces: spaces,
        activeSpaceId: firstId,
        activeSpaceName: firstName,
        kpis: kpis,
        recentActivity: activity,
      ));
    } catch (e) {
      emit(state.copyWith(status: AdminHomeStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSpaceChanged(AdminHomeSpaceChanged event, Emitter<AdminHomeState> emit) async {
    emit(state.copyWith(
      status: AdminHomeStatus.loading,
      activeSpaceId: event.spaceId,
      activeSpaceName: event.spaceName,
      error: null,
    ));
    try {
      final kpis = await getKpis(spaceId: event.spaceId);
      emit(state.copyWith(status: AdminHomeStatus.success, kpis: kpis));
    } catch (e) {
      emit(state.copyWith(status: AdminHomeStatus.failure, error: e.toString()));
    }
  }
}


