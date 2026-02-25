/// NOTE: API-ready skeleton.
/// لاحقًا هذا المصدر رح يستدعي API ويعمل parsing للـJSON.
class SearchResultsRemoteSource {
  // final Dio dio; أو HttpClient حسب مشروعكم

  const SearchResultsRemoteSource();

  /// لاحقًا:
  /// GET /spaces/search?query=... مع body/params للفلاتر + originKey
  /// Response: List<SpaceModel>
  Future<List<Map<String, dynamic>>> searchSpacesRaw({
    required String query,
    required Map<String, dynamic> selectedFilters,
    required String originKey,
  }) async {
    // حاليا Dummy:
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return <Map<String, dynamic>>[];
  }

  /// لاحقًا:
  /// GET /users/me/preferred-filters?originKey=...
  /// Response: List<FilterChipModel>
  Future<List<Map<String, dynamic>>> preferredChipsRaw({
    required String originKey,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return <Map<String, dynamic>>[];
  }
}