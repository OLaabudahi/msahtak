import '../models/space_request_model.dart';

abstract class SpaceRequestSource {
  Future<void> submitRequest(SpaceRequestModel model);
}

