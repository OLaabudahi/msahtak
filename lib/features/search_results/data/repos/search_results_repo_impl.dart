import '../../domain/entities/filter_chip_entity.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/repos/search_results_repo.dart';
import '../models/filter_chip_model.dart';
import '../models/space_model.dart';
import '../sources/search_results_remote_source.dart';

class SearchResultsRepoImpl implements SearchResultsRepo {
  final SearchResultsRemoteSource remote;

  const SearchResultsRepoImpl({required this.remote});

  @override
  Future<List<SpaceEntity>> searchSpaces({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    // API-ready:
    // - لاحقًا نستبدل الـdummy بremote.searchSpacesRaw(...)
    // - ثم نحول SpaceModel -> Entity
    // حاليا Dummy list:
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final dummy = <SpaceModel>[
      SpaceModel(
        id: '1',
        name: 'Space A – Study Friendly',
        locationName: 'City Center',
        distanceKm: 1.2,
        pricePerDay: 35,
        rating: 4.8,
        tags: const ['Quiet', 'Fast Wi-Fi'],
      ),
      SpaceModel(
        id: '2',
        name: 'Downtown Hub',
        locationName: 'City Center',
        distanceKm: 1.0,
        pricePerDay: 40,
        rating: 4.7,
        tags: const ['Fast Wi-Fi'],
      ),
    ];

    // تصفية بسيطة محليًا فقط للتجربة:
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? dummy
        : dummy.where((e) => e.name.toLowerCase().contains(q)).toList();

    return filtered.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<FilterChipEntity>> getPreferredFilterChips({
    required String originKey,
  }) async {
    // API-ready:
    // - لاحقًا نجيبها من remote.preferredChipsRaw(originKey)
    // - ثم نحول FilterChipModel -> Entity
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // حاليا Dummy (تظهر فقط بعد apply filters من الـBLoC)
    final chips = <FilterChipModel>[
      const FilterChipModel(id: 'quiet', label: 'Quiet'),
      const FilterChipModel(id: 'wifi_fast', label: 'Fast Wi-Fi'),
      const FilterChipModel(id: 'price_max_40', label: '₪40 max'),
    ];

    return chips.map((e) => e.toEntity()).toList();
  }
}