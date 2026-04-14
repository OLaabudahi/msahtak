import 'package:bloc/bloc.dart';

import '../domain/entities/usage_insight_entity.dart';
import '../domain/usecases/calculate_spending_usecase.dart';
import '../domain/usecases/calculate_usage_usecase.dart';
import '../domain/usecases/generate_recommendation_usecase.dart';
import '../domain/usecases/get_spaces_by_ids_usecase.dart';
import '../domain/usecases/get_user_bookings_usecase.dart';
import 'profile_usage_event.dart';
import 'profile_usage_state.dart';

class ProfileUsageBloc extends Bloc<ProfileUsageEvent, ProfileUsageState> {
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetSpacesByIdsUseCase getSpacesByIdsUseCase;
  final CalculateUsageUseCase calculateUsageUseCase;
  final CalculateSpendingUseCase calculateSpendingUseCase;
  final GenerateRecommendationUseCase generateRecommendationUseCase;

  ProfileUsageBloc({
    required this.getUserBookingsUseCase,
    required this.getSpacesByIdsUseCase,
    required this.calculateUsageUseCase,
    required this.calculateSpendingUseCase,
    required this.generateRecommendationUseCase,
  }) : super(ProfileUsageState.initial()) {
    on<ProfileUsageStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ProfileUsageStarted event,
    Emitter<ProfileUsageState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final bookings = await getUserBookingsUseCase();
      final spaceIds = bookings.map((b) => b.spaceId).toSet().toList(growable: false);
      final spaces = await getSpacesByIdsUseCase(spaceIds);

      final usage = calculateUsageUseCase(bookings);
      final spending = calculateSpendingUseCase(bookings: bookings, spaces: spaces);
      final recommendation = generateRecommendationUseCase(
        bookings: bookings,
        spaces: spaces,
        mostUsedPlan: usage.mostUsedPlan,
      );

      final insight = UsageInsightEntity(
        totalBookings: usage.totalBookings,
        dailyCount: usage.dailyCount,
        weeklyCount: usage.weeklyCount,
        monthlyCount: usage.monthlyCount,
        mostUsedPlan: usage.mostUsedPlan,
        favoriteSpaceId: usage.favoriteSpaceId,
        userType: usage.userType,
        repeatsSameSpace: usage.repeatsSameSpace,
        estimatedSpending: spending,
        estimatedSavings: recommendation.savings,
        recommendedPlan: recommendation.bestPlan,
        bestOffer: recommendation.offerInsight,
      );

      emit(state.copyWith(loading: false, insight: insight, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
