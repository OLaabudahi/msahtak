import 'package:equatable/equatable.dart';

import '../data/models/user_model.dart';

enum AuthStatus {
  idle,
  loading,
  success,
  error,
  forgotSent,
  loggedOut, // âœ… new
}

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.errorMessage});

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
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


