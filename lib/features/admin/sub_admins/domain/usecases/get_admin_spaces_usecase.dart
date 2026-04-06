import '../repos/sub_admins_repo.dart';

class GetAdminSpacesUseCase {
  final SubAdminsRepo repo;

  GetAdminSpacesUseCase(this.repo);

  Future<List<Map<String, dynamic>>> call() {
    return repo.getSpaces();
  }
}