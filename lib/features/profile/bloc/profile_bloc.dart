import 'package:Msahtak/features/profile/domain/usecases/sync_email_verification_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/sources/profile_firebase_source.dart';
import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../domain/usecases/verify_email_usecase.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;
  final ChangePasswordUseCase changePassword;
  final VerifyEmailUseCase verifyEmail;
  final SyncEmailVerificationUseCase syncEmailVerification;
  final ProfileFirebaseSource source;

  /// ✅ تحميل البيانات

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.changePassword,
    required this.verifyEmail,
    required this.syncEmailVerification,
    required this.source,
 }) : super(ProfileState.initial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefresh);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<ChangePasswordRequested>(_onChangePassword);
    on<VerifyEmailRequested>(_onVerifyEmail);
    on<CheckEmailVerifiedRequested>(_onCheckEmailVerified);
  }
  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final user = await getProfile(); // ✅ UseCase
      emit(state.copyWith(loading: false, user: user));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// 🔄 Refresh
  Future<void> _onRefresh(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = await getProfile(); // ✅ UseCase
      emit(state.copyWith(user: user, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// 💾 Update Profile
  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      await updateProfile(
        // ✅ UseCase
        name: event.name,
        email: event.email,
        phone: event.phone,
      );

      final user = await getProfile(); // 🔄 reload
      emit(state.copyWith(loading: false, user: user, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// 🔐 Change Password
  Future<void> _onChangePassword(
    ChangePasswordRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await changePassword(); // ✅ UseCase
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// 📩 Verify Email
  Future<void> _onVerifyEmail(
    VerifyEmailRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await verifyEmail(); // ✅ UseCase
      await Future.delayed(const Duration(seconds: 2));
      await source.refreshUser();
      final user = await getProfile(); // 🔄 reload
      emit(state.copyWith(user: user));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCheckEmailVerified(event, emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await source.syncEmailVerification();
      await user?.reload();
      final updatedUser = await getProfile();
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
