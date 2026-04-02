import '../models/user_model.dart';

abstract class UsersSource {
  Future<List<UserModel>> fetchUsers();
}


