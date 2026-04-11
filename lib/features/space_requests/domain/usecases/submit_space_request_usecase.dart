import '../entities/space_request_entity.dart';
import '../repos/space_request_repo.dart';

class SubmitSpaceRequestUseCase {
  final SpaceRequestRepo repo;

  SubmitSpaceRequestUseCase(this.repo);

  Future<void> call(SpaceRequestEntity request) {
    return repo.submitRequest(request);
  }
}
