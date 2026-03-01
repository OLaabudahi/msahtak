import '../../domain/entities/user_entity.dart';
import '../../domain/repos/auth_repo.dart';
import '../sources/auth_source.dart';

class AuthRepoDummy implements AuthRepo {
  final AuthSource source;
  AuthRepoDummy(this.source);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final model = await source.login(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final model = await source.signUp(fullName: fullName, email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<void> requestPasswordReset({required String email}) {
    return source.requestPasswordReset(email: email);
  }

  @override
  Future<void> logout() {
    return source.logout();
  }
}