import '../../../search_results/domain/entities/space_entity.dart';

abstract class SavedSpacesRepo {
  Future<List<SpaceEntity>> getSavedSpaces(List<String> favoriteIds);
}
