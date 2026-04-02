import '../entities/filter_chip_entity.dart';
import '../repos/search_results_repo.dart';

class GetPreferredFilterChipsUseCase {
  final SearchResultsRepo repo;

  const GetPreferredFilterChipsUseCase(this.repo);

  Future<List<FilterChipEntity>> call({
    required String originKey,
  }) {
    return repo.getPreferredFilterChips(originKey: originKey);
  }
}


