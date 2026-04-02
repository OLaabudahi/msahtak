import '../entities/user_entity.dart';
import '../entities/user_flag.dart';

abstract class UsersRepo {
  Future<List<UserEntity>> searchUsers({required String query, required UserFlag filter});
}


