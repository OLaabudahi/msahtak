import '../entities/filter_chip_entity.dart';
import '../entities/space_entity.dart';

abstract class SearchResultsRepo {
  Future<List<SpaceEntity>> searchSpaces({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  });

  Future<List<FilterChipEntity>> getPreferredFilterChips({
    required String originKey,
  });
}


