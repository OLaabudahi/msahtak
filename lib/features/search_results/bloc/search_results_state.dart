import 'package:equatable/equatable.dart';
import '../domain/entities/filter_chip_entity.dart';
import '../domain/entities/space_entity.dart';

class SearchResultsState extends Equatable {
  final String originKey;
  final String originTitle;
  final String query;
  final Map<String, dynamic> selectedFilters;
  final bool isLoading;
  final String? errorMessage;
  final List<SpaceEntity> results;
  final bool hasAppliedFilters;
  final List<FilterChipEntity> preferredChips;
  final List<String> suggestions;

  const SearchResultsState({
    required this.originKey,
    required this.originTitle,
    required this.query,
    required this.selectedFilters,
    required this.isLoading,
    required this.errorMessage,
    required this.results,
    required this.hasAppliedFilters,
    required this.preferredChips,
    required this.suggestions,
  });

  factory SearchResultsState.initial() {
    return const SearchResultsState(
      originKey: '',
      originTitle: 'Search Results',
      query: '',
      selectedFilters: <String, dynamic>{},
      isLoading: false,
      errorMessage: null,
      results: <SpaceEntity>[],
      hasAppliedFilters: false,
      preferredChips: <FilterChipEntity>[],
      suggestions: <String>[],
    );
  }

  SearchResultsState copyWith({
    String? originKey,
    String? originTitle,
    String? query,
    Map<String, dynamic>? selectedFilters,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<SpaceEntity>? results,
    bool? hasAppliedFilters,
    List<FilterChipEntity>? preferredChips,
    List<String>? suggestions,
  }) {
    return SearchResultsState(
      originKey: originKey ?? this.originKey,
      originTitle: originTitle ?? this.originTitle,
      query: query ?? this.query,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      results: results ?? this.results,
      hasAppliedFilters: hasAppliedFilters ?? this.hasAppliedFilters,
      preferredChips: preferredChips ?? this.preferredChips,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object?> get props => [
    originKey,
    originTitle,
    query,
    selectedFilters,
    isLoading,
    errorMessage,
    results,
    hasAppliedFilters,
    preferredChips,
    suggestions,
  ];
}
