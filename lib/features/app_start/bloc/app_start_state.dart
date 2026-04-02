import 'package:equatable/equatable.dart';
import '../domain/repos/app_start_repo.dart';

class AppStartState extends Equatable {
  const AppStartState({required this.loading, this.decision, this.error});

  final bool loading;
  final AppStartDecision? decision;
  final String? error;

  AppStartState copyWith({
    bool? loading,
    AppStartDecision? decision,
    String? error,
  }) {
    return AppStartState(
      loading: loading ?? this.loading,
      decision: decision ?? this.decision,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, decision, error];
}


