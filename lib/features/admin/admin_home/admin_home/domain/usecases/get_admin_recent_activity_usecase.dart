import '../entities/admin_activity_item.dart';
import '../repos/admin_home_repo.dart';

class GetAdminRecentActivityUseCase {
  final AdminHomeRepo repo;
  const GetAdminRecentActivityUseCase(repo) : repo = repo;

  Future<List<AdminActivityItem>> call() => repo.getRecentActivity();
}


