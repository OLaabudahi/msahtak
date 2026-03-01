import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repos/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState(status: AuthStatus.idle)) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthSignUpRequested>(_onSignup);
    on<AuthForgotPasswordRequested>(_onForgot);
    on<AuthLogoutRequested>(_onLogout);
  }

  final AuthRepo _repo;

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      final user = await _repo.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user, errorMessage: null));
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
      final user = await _repo.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user, errorMessage: null));
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
      await _repo.requestPasswordReset(email: event.email);
      emit(state.copyWith(status: AuthStatus.forgotSent, errorMessage: null));
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
      await _repo.logout();
      emit(const AuthState(status: AuthStatus.loggedOut));
      emit(const AuthState(status: AuthStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: AuthStatus.idle));
    }
  }
}