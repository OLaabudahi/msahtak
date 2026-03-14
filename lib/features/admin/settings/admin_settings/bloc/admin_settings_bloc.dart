import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/logout_usecase.dart';
import 'admin_settings_event.dart';
import 'admin_settings_state.dart';

class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  final LogoutUseCase logout;
  AdminSettingsBloc({required this.logout}) : super(AdminSettingsState.initial()) {
    on<AdminSettingsLogoutPressed>(_onLogout);
  }

  Future<void> _onLogout(AdminSettingsLogoutPressed event, Emitter<AdminSettingsState> emit) async {
    emit(state.copyWith(status: AdminSettingsStatus.loggingOut, error: null));
    try {
      await logout();
      emit(state.copyWith(status: AdminSettingsStatus.loggedOut));
    } catch (e) {
      emit(state.copyWith(status: AdminSettingsStatus.failure, error: e.toString()));
    }
  }
}
