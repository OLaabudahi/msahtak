import 'package:equatable/equatable.dart';

import '../domain/entities/usage_insight_entity.dart';


class ProfileUsageState extends Equatable {
  final bool loading;
  final String? error;
  final UsageInsightEntity insight;

  const ProfileUsageState({
    required this.loading,
    required this.error,
    required this.insight,
  });

  factory ProfileUsageState.initial() =>
      ProfileUsageState(loading: true, error: null, insight: UsageInsightEntity.empty());

  ProfileUsageState copyWith({
    bool? loading,
    String? error,
    UsageInsightEntity? insight,
  }) {
    return ProfileUsageState(
      loading: loading ?? this.loading,
      error: error,
      insight: insight ?? this.insight,
    );
  }

  @override
  List<Object?> get props => [loading, error, insight];
}
