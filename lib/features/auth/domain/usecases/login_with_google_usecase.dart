import 'package:Msahtak/features/auth/data/models/auth_user_model.dart';

import '../entities/auth_user.dart';
import '../repos/auth_repo.dart';

class LoginWithGoogleUseCase {
  final AuthRepo repo;

  LoginWithGoogleUseCase(this.repo);

  Future<AuthUserModel> call() {
    return repo.loginWithGoogle();
  }
}