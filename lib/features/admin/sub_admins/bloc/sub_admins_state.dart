class SubAdminsState {
  final bool loading;
  final List<Map<String, dynamic>> spaces;
  final List<Map<String, dynamic>> subAdmins;

  const SubAdminsState({
    this.loading = false,
    this.spaces = const [],
    this.subAdmins = const [],
  });

  SubAdminsState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? spaces,
    List<Map<String, dynamic>>? subAdmins,
  }) {
    return SubAdminsState(
      loading: loading ?? this.loading,
      spaces: spaces ?? this.spaces,
      subAdmins: subAdmins ?? this.subAdmins,
    );
  }
}