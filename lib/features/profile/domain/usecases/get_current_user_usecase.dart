import 'package:Msahtak/features/profile/data/models/user_model.dart';

import '../repos/profile_repo.dart';

class GetCurrentUserUseCase {
  final ProfileRepo repo;

  GetCurrentUserUseCase(this.repo);

  Future<UserModel> call() {
    return repo.fetchProfile();
  }
}