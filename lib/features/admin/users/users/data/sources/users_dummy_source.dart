import 'users_source.dart';
import '../models/user_model.dart';

class UsersDummySource implements UsersSource {
  @override
  Future<List<UserModel>> fetchUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    return const [
      UserModel(id: 'u1', name: 'Sarah Johnson', avatar: 'SJ', status: 'active', flagged: false),
      UserModel(id: 'u2', name: 'Mike Chen', avatar: 'MC', status: 'active', flagged: true),
      UserModel(id: 'u3', name: 'Emily Brown', avatar: 'EB', status: 'blocked', flagged: false),
      UserModel(id: 'u4', name: 'John Smith', avatar: 'JS', status: 'active', flagged: false),
    ];
  }
}
