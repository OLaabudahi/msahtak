import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_preferred_filter_chips_usecase.dart';
import '../domain/usecases/search_spaces_usecase.dart';
import 'search_results_event.dart';
import 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final SearchSpacesUseCase searchSpacesUseCase;
  final GetPreferredFilterChipsUseCase getPreferredFilterChipsUseCase;

  SearchResultsBloc({
    required this.searchSpacesUseCase,
    required this.getPreferredFilterChipsUseCase,
  }) : super(SearchResultsState.initial()) {
    on<SearchResultsStarted>(_onStarted);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchApplyFilters>(_onApplyFilters);
    on<SearchRemovePreferredChip>(_onRemoveChip);
    on<SearchRefresh>(_onRefresh);
    on<SearchSuggestionSelected>(_onSuggestionSelected);
  }

  Future<void> _onStarted(
      SearchResultsStarted event,
      Emitter<SearchResultsState> emit,
      ) async {
    emit(state.copyWith(
      originKey: event.originKey,
      originTitle: event.originTitle,
      isLoading: true,
      errorMessage: null,
    ));

    final results = await searchSpacesUseCase(
      query: state.query,
      selectedFilters: state.selectedFilters,
      originKey: event.originKey,
    );

    emit(state.copyWith(isLoading: false, results: results, errorMessage: null));
  }
  Future<void> _onQueryChanged(
      SearchQueryChanged event,
      Emitter<SearchResultsState> emit,
      ) async {
    final q = event.query.trim();
    emit(state.copyWith(query: q, errorMessage: null));

    // Dummy suggestions (API-ready):
    // لاحقًا: GET /spaces/suggestions?query=q
    if (q.isEmpty) {
      emit(state.copyWith(suggestions: const <String>[]));
    } else {
      final pool = state.results.map((e) => e.name).toList();
      final sug = pool
          .where((name) => name.toLowerCase().contains(q.toLowerCase()))
          .take(6)
          .toList();
      emit(state.copyWith(suggestions: sug));
    }

    // اعملي بحث فعلي فقط لو بدك "live search" مع كل حرف:
    emit(state.copyWith(isLoading: true));
    final results = await searchSpacesUseCase(
      query: q,
      selectedFilters: state.selectedFilters,
      originKey: state.originKey,
    );
    emit(state.copyWith(isLoading: false, results: results));
  }

  Future<void> _onSuggestionSelected(
      SearchSuggestionSelected event,
      Emitter<SearchResultsState> emit,
      ) async {
    final v = event.value.trim();
    emit(state.copyWith(query: v, suggestions: const <String>[], isLoading: true));

    final results = await searchSpacesUseCase(
      query: v,
      selectedFilters: state.selectedFilters,
      originKey: state.originKey,
    );

    emit(state.copyWith(isLoading: false, results: results));
  }

  Future<void> _onApplyFilters(
      SearchApplyFilters event,
      Emitter<SearchResultsState> emit,
      ) async {
    emit(state.copyWith(
      selectedFilters: event.selectedFilters,
      hasAppliedFilters: true,
      isLoading: true,
      errorMessage: null,
    ));

    // 1) نجيب النتائج بناء على الفلاتر
    final results = await searchSpacesUseCase(
      query: state.query,
      selectedFilters: event.selectedFilters,
      originKey: state.originKey,
    );

    // 2) نجيب preferred chips (لاحقًا من API)
    final chips = await getPreferredFilterChipsUseCase(originKey: state.originKey);

    emit(state.copyWith(
      isLoading: false,
      results: results,
      preferredChips: chips,
      errorMessage: null,
    ));
  }

  void _onRemoveChip(
      SearchRemovePreferredChip event,
      Emitter<SearchResultsState> emit,
      ) {
    final updated = state.preferredChips.where((c) => c.id != event.chipId).toList();
    emit(state.copyWith(preferredChips: updated));
  }

  Future<void> _onRefresh(
      SearchRefresh event,
      Emitter<SearchResultsState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final results = await searchSpacesUseCase(
      query: state.query,
      selectedFilters: state.selectedFilters,
      originKey: state.originKey,
    );

    emit(state.copyWith(isLoading: false, results: results, errorMessage: null));
  }
}