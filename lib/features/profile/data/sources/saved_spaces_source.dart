import '../../../search_results/domain/entities/space_entity.dart';

abstract class SavedSpacesSource {
  Future<List<SpaceEntity>> fetchSavedSpaces(List<String> favoriteIds);
}
