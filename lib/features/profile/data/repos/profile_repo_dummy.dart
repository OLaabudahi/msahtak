import '../../../../constants/app_assets.dart';
import '../models/user_model.dart';
import 'profile_repo.dart';

class ProfileRepoDummy implements ProfileRepo {
  @override
  Future<UserModel> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const UserModel(
      userId: 'u_101',
      fullName: 'Sarah Ahmad',
      email: 'sarah@example.com',
      avatarAsset: AppAssets.home,
      totalBookings: 12,
      completedBookings: 9,
      savedSpaces: 4,
    );

    // ✅ API READY (كومنت)
    // final res = await dio.get('/profile');
    // return UserModel.fromJson(res.data);
  }
}
