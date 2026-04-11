import '../entities/space_request_entity.dart';

abstract class SpaceRequestRepo {
  Future<void> submitRequest(SpaceRequestEntity request);
}
