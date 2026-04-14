import '../../../../constants/app_assets.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../../domain/repos/profile_repo.dart';

class ProfileRepoDummy implements ProfileRepo {
  @override
  Future<UserModel> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const UserModel(
      userId: '1',
      fullName: 'Asma Yazin',
      email: 'asma_yaza@gmail.com',
      phoneNumber: '+970 595 959 595',
      avatarAsset: 'assets/images/home.png',
      totalBookings: 12,
      isEmailVerified: false,
      completedBookings: 5,
      savedSpaces: 7,
    );

    // ✅ API READY (كومنت)
    // final res = await dio.get('/profile');
    // return UserModel.fromJson(res.data);
  }

  @override
  Future<void> changePassword() {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }

  @override
  Future<void> syncEmailVerification() {
    // TODO: implement syncEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfileImage(XFile file) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}
