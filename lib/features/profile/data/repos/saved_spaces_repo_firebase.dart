import '../../../search_results/domain/entities/space_entity.dart';
import '../../domain/repos/saved_spaces_repo.dart';
import '../sources/saved_spaces_source.dart';

class SavedSpacesRepoFirebase implements SavedSpacesRepo {
  final SavedSpacesSource source;

  SavedSpacesRepoFirebase(this.source);

  @override
  Future<List<SpaceEntity>> getSavedSpaces(List<String> favoriteIds) {
    return source.fetchSavedSpaces(favoriteIds);
  }
}
