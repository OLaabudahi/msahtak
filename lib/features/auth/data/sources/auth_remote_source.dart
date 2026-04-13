import '../../../../services/auth_service.dart';
import '../models/auth_user_model.dart';

class AuthRemoteSource {
  final AuthService _service = AuthService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _service.signIn(email: email, password: password);
    final user = result['user'];
    return {
      ...result,
      'uid': user?.uid,
      'email': user?.email,
      'displayName': user?.displayName,
    };
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final result = await _service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    final user = result['user'];
    return {
      ...result,
      'uid': user?.uid,
      'email': user?.email,
    };
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

  Future<Map<String, dynamic>?> getUserProfile({required String uid}) {
    return _service.getUserProfile(uid: uid);
  }
}
