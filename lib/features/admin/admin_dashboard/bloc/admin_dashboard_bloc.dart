import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/admin_dashboard_data_entity.dart';
import '../domain/usecases/get_admin_dashboard_data_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetAdminDashboardDataUseCase _getData;

  AdminDashboardBloc(this._getData)
      : super(const AdminDashboardState(status: AdminDashboardStatus.idle)) {
    on<AdminDashboardStarted>(_onStarted);
    on<AdminDashboardDropdownToggled>(_onToggleDropdown);
    on<AdminDashboardSpaceSelected>(_onSpaceSelected);
    on<AdminDashboardNavChanged>(_onNavChanged);
  }

  Future<void> _onStarted(
    AdminDashboardStarted event,
    Emitter<AdminDashboardState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminDashboardStatus.loading, errorMessage: null));
      final data = await _getData();
      emit(state.copyWith(status: AdminDashboardStatus.success, data: data));
    } catch (e) {
      emit(state.copyWith(status: AdminDashboardStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AdminDashboardStatus.idle));
    }
  }

  void _onToggleDropdown(
    AdminDashboardDropdownToggled event,
    Emitter<AdminDashboardState> emit,
  ) {
    emit(state.copyWith(dropdownOpen: !state.dropdownOpen));
  }

  void _onSpaceSelected(
    AdminDashboardSpaceSelected event,
    Emitter<AdminDashboardState> emit,
  ) {
    final data = state.data;
    if (data == null) return;

    
    final updated = data.copyWith(selectedSpace: event.space);
    emit(state.copyWith(data: updated, dropdownOpen: false));
  }

  void _onNavChanged(
    AdminDashboardNavChanged event,
    Emitter<AdminDashboardState> emit,
  ) {
    emit(state.copyWith(navIndex: event.index));
  }
}


