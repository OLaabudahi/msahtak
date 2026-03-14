import '../repos/admin_home_repo.dart';

class GetAdminSpacesUseCase {
  final AdminHomeRepo repo;
  const GetAdminSpacesUseCase(this.repo);

  Future<List<String>> call() => repo.getSpaces();
}
