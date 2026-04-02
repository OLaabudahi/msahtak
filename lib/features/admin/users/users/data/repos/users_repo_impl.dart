import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_flag.dart';
import '../../domain/repos/users_repo.dart';
import '../sources/users_source.dart';

class UsersRepoImpl implements UsersRepo {
  final UsersSource source;
  const UsersRepoImpl(this.source);

  @override
  Future<List<UserEntity>> searchUsers({required String query, required UserFlag filter}) async {
    final list = (await source.fetchUsers()).map((m) => m.toEntity()).toList(growable: false);
    final q = query.trim().toLowerCase();

    Iterable<UserEntity> res = list;
    if (q.isNotEmpty) {
      res = res.where((u) => u.name.toLowerCase().contains(q));
    }

    switch (filter) {
      case UserFlag.newUsers:
        res = res.take(2);
        break;
      case UserFlag.flagged:
        res = res.where((u) => u.flagged);
        break;
      case UserFlag.all:
        break;
    }

    return res.toList(growable: false);
  }
}


