import 'package:equatable/equatable.dart';
import '../domain/entities/best_for_you_space.dart';
import '../domain/entities/fit_score.dart';

class BestForYouState extends Equatable {
  final BestForYouSpace? space;
  final FitScore? fitScore;
  final String selectedGoal;
  final List<String> goals;
  final bool isLoading;
  final String? error;

  /// قائمة أعلى 5 مساحات تقييماً ضمن 100 متر
  final List<BestForYouSpace> topSpaces;

  const BestForYouState({
    this.space,
    this.fitScore,
    this.selectedGoal = 'Study',
    this.goals = const ['Study', 'Work', 'Meeting', 'Relax'],
    this.isLoading = false,
    this.error,
    this.topSpaces = const [],
  });

  BestForYouState copyWith({
    BestForYouSpace? space,
    FitScore? fitScore,
    String? selectedGoal,
    bool? isLoading,
    String? error,
    List<BestForYouSpace>? topSpaces,
  }) {
    return BestForYouState(
      space: space ?? this.space,
      fitScore: fitScore ?? this.fitScore,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      goals: goals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      topSpaces: topSpaces ?? this.topSpaces,
    );
  }

  @override
  List<Object?> get props =>
      [space, fitScore, selectedGoal, goals, isLoading, error, topSpaces];
}
