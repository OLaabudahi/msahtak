import '../entities/user_entity.dart';
import '../entities/user_flag.dart';
import '../repos/users_repo.dart';

class SearchUsersUseCase {
  final UsersRepo repo;
  const SearchUsersUseCase(this.repo);

  Future<List<UserEntity>> call({required String query, required UserFlag filter}) {
    return repo.searchUsers(query: query, filter: filter);
  }
}


