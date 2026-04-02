class SearchResultsRemoteSource {
  const SearchResultsRemoteSource();

  
  Future<List<Map<String, dynamic>>> searchSpacesRaw({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return <Map<String, dynamic>>[];
  }

  
  Future<List<Map<String, dynamic>>> preferredChipsRaw({
    required String originKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return <Map<String, dynamic>>[];
  }
}
