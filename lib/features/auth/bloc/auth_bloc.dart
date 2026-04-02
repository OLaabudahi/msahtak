import 'package:Msahtak/features/auth/domain/usecases/logout_auth_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../admin/settings/admin_settings/domain/usecases/logout_usecase.dart';
import '../data/models/auth_user_model.dart';
import '../domain/usecases/forgot_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/login_with_google_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgotPasswordUseCase forgotUseCase;
  final LogoutAuthUseCase logoutUseCase;
  final LoginWithGoogleUseCase googleUseCase;


  AuthBloc({required this.loginUseCase,
    required this.signUpUseCase,
    required this.forgotUseCase,
    required this.logoutUseCase,
    required this.googleUseCase})
      : super(const AuthState(status: AuthStatus.idle)) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignUpRequested>(_onSignup);
    on<AuthForgotPasswordRequested>(_onForgot);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
  }


  Future<void> _onLogin(AuthLoginRequested event,
      Emitter<AuthState> emit,) async {
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
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onSignup(AuthSignUpRequested event,
      Emitter<AuthState> emit,) async {
    try {
      if (event.password != event.confirmPassword) {
        throw Exception('Passwords do not match');
      }

      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      final user = await signUpUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onForgot(AuthForgotPasswordRequested event,
      Emitter<AuthState> emit,) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      await forgotUseCase(event.email);
      emit(state.copyWith(status: AuthStatus.forgotSent, errorMessage: null));
      emit(state.copyWith(status: AuthStatus.idle));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event,
      Emitter<AuthState> emit,) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      await logoutUseCase();

      emit(const AuthState(status: AuthStatus.loggedOut));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }
  Future<void> _onGoogleLogin(
      AuthGoogleLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      final user = await googleUseCase();

      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          errorMessage: null,
        ),
      );

    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }
 /* Future<void> _onGoogleLogin(
      AuthGoogleLoginRequested event,
      Emitter<AuthState> emit,
      )
  async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

      final user = await googleUseCase();


      emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }*/
}
