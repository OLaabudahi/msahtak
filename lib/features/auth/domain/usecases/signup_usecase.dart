import '../../data/models/auth_user_model.dart';
import '../repos/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo repo;

  SignUpUseCase(this.repo);

  Future<AuthUserModel> call({
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
/*import '../repos/auth_repo.dart';

class SignupUseCase {
  final AuthRepo repo;

  SignupUseCase(this.repo);

  Future call(String email, String password) {
    return repo.signup(email, password);
  }
}*/


