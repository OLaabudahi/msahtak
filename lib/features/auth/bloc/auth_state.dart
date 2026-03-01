import 'package:equatable/equatable.dart';
import '../domain/entities/user_entity.dart';

enum AuthStatus {
  idle,
  loading,
  success,
  error,
  forgotSent,
  loggedOut,
}

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.errorMessage});

  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}