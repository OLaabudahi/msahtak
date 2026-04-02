import '../../../../services/auth_service.dart';
import '../models/auth_user_model.dart';

class AuthRemoteSource {
  final AuthService _service = AuthService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _service.signIn(email: email, password: password);
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<AuthUserModel> loginWithGoogle() {
    return _service.loginWithGoogle();
  }

  Future<Map<String, dynamic>> resetPassword(String email) {
    return _service.resetPassword(email);
  }

  Future<void> logout() {

    return _service.signOut();
  }
}