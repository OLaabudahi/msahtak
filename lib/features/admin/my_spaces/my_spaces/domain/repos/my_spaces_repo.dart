import '../entities/space_entity.dart';

abstract class MySpacesRepo {
  Future<List<SpaceEntity>> getSpaces();
  Future<void> hideSpace({required String spaceId});
}
