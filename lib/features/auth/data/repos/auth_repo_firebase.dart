import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../services/auth_service.dart';
import '../../../../services/local_storage_service.dart';
import '../../domain/repos/auth_repo.dart';
import '../models/user_model.dart';
import '../sources/auth_firebase_source.dart';

class AuthRepoFirebase implements AuthRepo {
  final LocalStorageService _storage;

  AuthRepoFirebase(this._storage,this.source);
  final AuthFirebaseSource source;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    debugPrint('[Auth] login attempt: $email');
    final result = await source.login(email: email, password: password);
    debugPrint('[Auth] signIn result: success=${result['success']}, role=${result['role']}, error=${result['error']}');
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);
      // ط§ظ„ظ…ط³طھط®ط¯ظ… ط³ط¬ظ‘ظ„ ط¯ط®ظˆظ„ظ‡ = ط£ظƒظ…ظ„ ط§ظ„طھط³ط¬ظٹظ„ ظ‚ط¨ظ„طŒ ظ„ط§ ظ†ط±ظٹظ‡ onboarding
      await _storage.setHasCompletedOnboarding(true);
      // ط­ظپط¸ ط¯ظˆط± ط§ظ„ظ…ط³طھط®ط¯ظ… ظ„طھط­ط¯ظٹط¯ ط§ظ„طھظˆط¬ظٹظ‡ (ظ…ط³طھط®ط¯ظ… ط¹ط§ط¯ظٹ ط£ظˆ ط£ط¯ظ…ظ†)
      await _storage.setUserRole(result['role'] as String? ?? 'user');
      // ط­ظپط¸ ط§ظ„ظ…ط³ط§ط­ط§طھ ط§ظ„ظ…ط®طµطµط© ظ„ظ„ظ…ط´ط±ظپ ط§ظ„ظپط±ط¹ظٹ
      final ids = result['assignedSpaceIds'];
      if (ids is List<String>) await _storage.setAssignedSpaceIds(ids);

      Map<String, dynamic> data = {};
      try {
        data = await source.getUserData(user.uid) ?? {};
      } catch (e) {
        debugPrint('[Auth] Firestore profile read failed (non-fatal): $e');
      }

      return UserModel(
        id: user.uid,
        fullName: data['fullName'] as String? ??
            user.displayName ??
            'User',
        email: user.email ?? email,
      );
    }
    throw Exception(result['error'] ?? 'Login failed');
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await source.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    if (result['success'] == true) {
      final user = result['user'] as User;
      await _storage.setIsLoggedIn(true);
      await _storage.setHasCompletedOnboarding(false);
      return UserModel(id: user.uid, fullName: fullName, email: email);
    }
    throw Exception(result['error'] ?? 'Sign up failed');
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final result = await source.resetPassword(email);
    if (result['success'] != true) {
      throw Exception(result['error'] ?? 'Password reset failed');
    }
  }

  @override
  Future<void> logout() async {
    await source.signOut();
    await _storage.clearAuth();
  }
}
/*import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/reset_password_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.resetPasswordUseCase,
  }) : super(const AuthState(status: AuthStatus.idle)) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignUpRequested>(_onSignup);
    on<AuthForgotPasswordRequested>(_onForgot);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onSignup(
      AuthSignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      if (event.password != event.confirmPassword) {
        throw Exception('Passwords do not match');
      }

      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      final user = await signupUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onForgot(
      AuthForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      await resetPasswordUseCase(event.email);

      emit(state.copyWith(status: AuthStatus.forgotSent));
      emit(state.copyWith(status: AuthStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onLogout(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      await logoutUseCase();

      emit(const AuthState(status: AuthStatus.loggedOut));
      emit(const AuthState(status: AuthStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }
}*/

