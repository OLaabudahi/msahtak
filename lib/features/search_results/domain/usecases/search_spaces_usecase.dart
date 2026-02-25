import '../entities/space_entity.dart';
import '../repos/search_results_repo.dart';

class SearchSpacesUseCase {
  final SearchResultsRepo repo;

  const SearchSpacesUseCase(this.repo);

  Future<List<SpaceEntity>> call({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) {
    return repo.searchSpaces(
      query: query,
      selectedFilters: selectedFilters,
      originKey: originKey,
    );
  }
}