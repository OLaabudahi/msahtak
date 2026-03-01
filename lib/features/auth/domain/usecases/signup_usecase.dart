import '../entities/user_entity.dart';
import '../repos/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo repo;
  const SignUpUseCase(this.repo);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return repo.signUp(fullName: fullName, email: email, password: password);
  }
}