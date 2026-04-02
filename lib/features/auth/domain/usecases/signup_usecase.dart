import '../repos/auth_repo.dart';
import '../../data/models/user_model.dart';

class SignupUseCase {
  final AuthRepo repo;

  SignupUseCase(this.repo);

  Future<UserModel> call({
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


