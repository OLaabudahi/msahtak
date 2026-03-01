import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> requestPasswordReset({required String email});

  Future<void> logout();
}