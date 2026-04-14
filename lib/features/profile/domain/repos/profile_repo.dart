import 'package:Msahtak/features/admin/users/users/domain/entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';

abstract class ProfileRepo {
  Future<UserModel> fetchProfile();
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  });

  Future<void> changePassword();

  Future<void> verifyEmail();
  Future<String> uploadProfileImage(XFile file);

  Future<void> syncEmailVerification() async {}
}

