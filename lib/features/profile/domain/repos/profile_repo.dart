import '../../data/models/user_model.dart';

abstract class ProfileRepo {
  Future<UserModel> fetchProfile();
}


