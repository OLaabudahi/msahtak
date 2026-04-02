import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future call({required String email, required String password}) {
    return repo.login(email: email, password: password);
  }
}