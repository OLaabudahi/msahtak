import '../repos/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo repo;

  SignUpUseCase(this.repo);

  Future call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return repo.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}