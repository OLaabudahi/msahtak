import 'package:Msahtak/features/admin/users/users/domain/entities/user_entity.dart';

import '../../data/models/user_model.dart';

abstract class ProfileRepo {
  Future<UserModel> fetchProfile();
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  });

  Future<void> changePassword();

  Future<void> verifyEmail();

  Future<void> syncEmailVerification() async {}
}


