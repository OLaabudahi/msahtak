import '../models/space_model.dart';

abstract class MySpacesSource {
  Future<List<SpaceModel>> fetchSpaces();
  Future<void> hideSpace({required String spaceId});
}
