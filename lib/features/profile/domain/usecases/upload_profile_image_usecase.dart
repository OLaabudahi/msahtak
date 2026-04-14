import 'package:image_picker/image_picker.dart';

import '../repos/profile_repo.dart';

class UploadProfileImageUseCase {
  final ProfileRepo repo;

  UploadProfileImageUseCase(this.repo);

  Future<String> call(XFile file) {
    return repo.uploadProfileImage(file);
  }
}
