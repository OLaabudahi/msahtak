import 'package:equatable/equatable.dart';
import '../domain/entities/plan_option.dart';
import '../domain/entities/usage_stats.dart';

class UsageState extends Equatable {
  final UsageStats? stats;
  final List<PlanOption> plans;
  final int selectedPlanIndex;
  final bool isLoading;
  final bool isApplying;
  final bool isApplied;
  final String? error;

  const UsageState({
    this.stats,
    this.plans = const [],
    this.selectedPlanIndex = 1, // Weekly by default
    this.isLoading = false,
    this.isApplying = false,
    this.isApplied = false,
    this.error,
  });

  UsageState copyWith({
    UsageStats? stats,
    List<PlanOption>? plans,
    int? selectedPlanIndex,
    bool? isLoading,
    bool? isApplying,
    bool? isApplied,
    String? error,
  }) {
    return UsageState(
      stats: stats ?? this.stats,
      plans: plans ?? this.plans,
      selectedPlanIndex:
          selectedPlanIndex ?? this.selectedPlanIndex,
      isLoading: isLoading ?? this.isLoading,
      isApplying: isApplying ?? this.isApplying,
      isApplied: isApplied ?? this.isApplied,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        plans,
        selectedPlanIndex,
        isLoading,
        isApplying,
        isApplied,
        error,
      ];
}
