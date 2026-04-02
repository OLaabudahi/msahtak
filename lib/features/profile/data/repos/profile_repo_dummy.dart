import '../../../../constants/app_assets.dart';
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
      completedBookings: 5,
      savedSpaces: 7,
    );

    
    
    
  }
}
