import '../entities/user_entity.dart';
import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repo;
  const LoginUseCase(this.repo);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repo.login(email: email, password: password);
  }
}