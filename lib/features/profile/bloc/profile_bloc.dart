import 'package:bloc/bloc.dart';
import '../domain/repos/profile_repo.dart';
import '../data/repos/profile_repo_dummy.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo repo;

  ProfileBloc({ProfileRepo? repo})
    : repo = repo ?? ProfileRepoDummy(),
      super(ProfileState.initial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefresh);
  }

  /// ✅ تحميل بيانات المستخدم
  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final user = await repo.fetchProfile();
      emit(state.copyWith(loading: false, user: user));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// ✅ Refresh
  Future<void> _onRefresh(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = await repo.fetchProfile();
      emit(state.copyWith(user: user, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
