import 'package:equatable/equatable.dart';

abstract class SearchResultsEvent extends Equatable {
  const SearchResultsEvent();
  @override
  List<Object?> get props => [];
}

class SearchResultsStarted extends SearchResultsEvent {
  final String originKey;   // e.g. "new_suggestion" / "private_office" / "nearly"
  final String originTitle; // يظهر كعنوان الصفحة

  const SearchResultsStarted({
    required this.originKey,
    required this.originTitle,
  });

  @override
  List<Object?> get props => [originKey, originTitle];
}

class SearchQueryChanged extends SearchResultsEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchApplyFilters extends SearchResultsEvent {
  final Map<String, dynamic> selectedFilters; // من شاشة الفلاتر لاحقًا
  const SearchApplyFilters(this.selectedFilters);

  @override
  List<Object?> get props => [selectedFilters];
}

class SearchRemovePreferredChip extends SearchResultsEvent {
  final String chipId;
  const SearchRemovePreferredChip(this.chipId);

  @override
  List<Object?> get props => [chipId];
}
class SearchSuggestionSelected extends SearchResultsEvent {
  final String value;
  const SearchSuggestionSelected(this.value);

  @override
  List<Object?> get props => [value];
}
class SearchRefresh extends SearchResultsEvent {
  const SearchRefresh();
}