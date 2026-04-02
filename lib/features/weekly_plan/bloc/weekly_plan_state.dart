import 'package:equatable/equatable.dart';
import '../domain/entities/hub.dart';
import '../domain/entities/weekly_plan_details.dart';

class WeeklyPlanState extends Equatable {
  final List<Hub> hubs;
  final WeeklyPlanDetails? planDetails;
  final String selectedHubId;
  final bool isLoading;
  final bool isActivating;
  final bool isActivated;
  final String? error;

  const WeeklyPlanState({
    this.hubs = const [],
    this.planDetails,
    this.selectedHubId = 'h1',
    this.isLoading = false,
    this.isActivating = false,
    this.isActivated = false,
    this.error,
  });

  WeeklyPlanState copyWith({
    List<Hub>? hubs,
    WeeklyPlanDetails? planDetails,
    String? selectedHubId,
    bool? isLoading,
    bool? isActivating,
    bool? isActivated,
    String? error,
  }) {
    return WeeklyPlanState(
      hubs: hubs ?? this.hubs,
      planDetails: planDetails ?? this.planDetails,
      selectedHubId: selectedHubId ?? this.selectedHubId,
      isLoading: isLoading ?? this.isLoading,
      isActivating: isActivating ?? this.isActivating,
      isActivated: isActivated ?? this.isActivated,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        hubs,
        planDetails,
        selectedHubId,
        isLoading,
        isActivating,
        isActivated,
        error,
      ];
}
