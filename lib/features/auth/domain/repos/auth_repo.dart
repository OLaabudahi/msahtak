import '../../data/models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});

  Future<void> logout();
}
