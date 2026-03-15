import '../entities/admin_space_item.dart';
import '../repos/admin_home_repo.dart';

class GetAdminSpacesUseCase {
  final AdminHomeRepo repo;
  const GetAdminSpacesUseCase(this.repo);

  Future<List<AdminSpaceItem>> call() => repo.getSpaces();
}
