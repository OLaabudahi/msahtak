import '../entities/space_entity.dart';
import '../repos/search_results_repo.dart';
import 'filter_spaces_usecase.dart';

class SearchSpacesUseCase {
  final SearchResultsRepo repo;
  final FilterSpacesUseCase filterSpacesUseCase;

  const SearchSpacesUseCase(this.repo, this.filterSpacesUseCase);

  Future<List<SpaceEntity>> call({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    final raw = await repo.searchSpaces(
      query: query,
      selectedFilters: selectedFilters,
      originKey: originKey,
    );

    return filterSpacesUseCase(
      spaces: raw,
      selectedFilters: selectedFilters,
    );
  }
}
