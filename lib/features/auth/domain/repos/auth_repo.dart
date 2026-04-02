import '../../data/models/auth_user_model.dart';

abstract class AuthRepo {
  Future<AuthUserModel> login({required String email, required String password});

  Future<AuthUserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});
  Future<AuthUserModel> loginWithGoogle();
  Future<void> logout();
}


