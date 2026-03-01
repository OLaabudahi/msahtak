import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/add_user_note_usecase.dart';
import '../domain/usecases/approve_user_usecase.dart';
import '../domain/usecases/block_user_usecase.dart';
import '../domain/usecases/get_user_profile_usecase.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getProfile;
  final ApproveUserUseCase approve;
  final BlockUserUseCase block;
  final AddUserNoteUseCase addNote;

  UserProfileBloc({
    required this.getProfile,
    required this.approve,
    required this.block,
    required this.addNote,
  }) : super(UserProfileState.initial()) {
    on<UserProfileStarted>(_onStarted);
    on<UserProfileApprovePressed>(_onApprove);
    on<UserProfileBlockPressed>(_onBlock);
    on<UserProfileAddNotePressed>(_onNote);
  }

  Future<void> _onStarted(UserProfileStarted event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.loading, error: null));
    try {
      final p = await getProfile(userId: event.userId);
      emit(state.copyWith(status: UserProfileStatus.ready, profile: p));
    } catch (e) {
      emit(state.copyWith(status: UserProfileStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onApprove(UserProfileApprovePressed event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.acting, error: null));
    await approve(userId: event.userId);
    add(UserProfileStarted(event.userId));
  }

  Future<void> _onBlock(UserProfileBlockPressed event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.acting, error: null));
    await block(userId: event.userId);
    add(UserProfileStarted(event.userId));
  }

  Future<void> _onNote(UserProfileAddNotePressed event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.acting, error: null));
    await addNote(userId: event.userId, note: event.note);
    add(UserProfileStarted(event.userId));
  }
}
