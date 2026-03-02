/// NOTE: API-ready skeleton.
class SearchResultsRemoteSource {
  const SearchResultsRemoteSource();

  /// GET /spaces/search?query=... مع body/params للفلاتر + originKey
  Future<List<Map<String, dynamic>>> searchSpacesRaw({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return <Map<String, dynamic>>[];
  }

  /// GET /users/me/preferred-filters?originKey=...
  Future<List<Map<String, dynamic>>> preferredChipsRaw({
    required String originKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return <Map<String, dynamic>>[];
  }
}
