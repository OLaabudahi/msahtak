import '../../data/models/auth_user_model.dart';
import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future<AuthUserModel> call({
    required String email,
    required String password,
  }) {
    return repo.login(
      email: email,
      password: password,
    );
  }
}
/*
import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future call(String email, String password) {
    return repo.login(email, password);
  }
}
*/


