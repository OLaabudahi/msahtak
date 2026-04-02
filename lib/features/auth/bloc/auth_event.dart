import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
class AuthGoogleLoginRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}


