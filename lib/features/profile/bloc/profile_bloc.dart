import 'package:Msahtak/features/profile/domain/usecases/sync_email_verification_usecase.dart';
import 'package:bloc/bloc.dart';

import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/upload_profile_image_usecase.dart';
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
  final UploadProfileImageUseCase uploadProfileImage;

  /// ✅ تحميل البيانات

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.changePassword,
    required this.verifyEmail,
    required this.syncEmailVerification,
    required this.uploadProfileImage,
 }) : super(ProfileState.initial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefresh);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<ChangePasswordRequested>(_onChangePassword);
    on<VerifyEmailRequested>(_onVerifyEmail);
    on<CheckEmailVerifiedRequested>(_onCheckEmailVerified);
    on<ProfileAvatarUploadRequested>(_onAvatarUpload);
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
        avatarUrl: event.avatarUrl,
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
      await syncEmailVerification();
      final user = await getProfile(); // 🔄 reload
      emit(state.copyWith(user: user));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onCheckEmailVerified(event, emit) async {
    try {
      await syncEmailVerification();
      final updatedUser = await getProfile();
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onAvatarUpload(
    ProfileAvatarUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.user;
    if (current == null) return;

    emit(state.copyWith(loading: true));
    try {
      final avatarUrl = await uploadProfileImage(event.file);
      await updateProfile(
        name: current.fullName,
        email: current.email,
        phone: current.phoneNumber ?? '',
        avatarUrl: avatarUrl,
      );
      final user = await getProfile();
      emit(state.copyWith(loading: false, user: user, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
