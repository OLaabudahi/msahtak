import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/i18n/app_i18n.dart';
import '../../../../theme/app_colors.dart';
import '../../../../core/di/app_injector.dart';
import '../../booking_request/bloc/booking_request_event.dart';
import '../../booking_request/domain/entities/booking_request_entity.dart';
import '../../booking_request/view/booking_request_routes.dart';
import '../bloc/profile_usage_bloc.dart';
import '../bloc/profile_usage_event.dart';
import '../bloc/profile_usage_state.dart';
import '../data/repos/profile_usage_repo_firebase.dart';
import '../data/services/profile_usage_firebase_service.dart';
import '../data/sources/profile_usage_source.dart';
import '../domain/usecases/calculate_spending_usecase.dart';
import '../domain/usecases/calculate_usage_usecase.dart';
import '../domain/usecases/generate_recommendation_usecase.dart';
import '../domain/usecases/get_spaces_by_ids_usecase.dart';
import '../domain/usecases/get_user_bookings_usecase.dart';

class ProfileUsagePage extends StatelessWidget {
  const ProfileUsagePage({super.key});

  static Widget withBloc() {
    final service = ProfileUsageFirebaseService();
    final source = ProfileUsageSource(service);
    final repo = ProfileUsageRepoFirebase(source);

    return BlocProvider(
      create: (_) => ProfileUsageBloc(
        getUserBookingsUseCase: GetUserBookingsUseCase(repo),
        getSpacesByIdsUseCase: GetSpacesByIdsUseCase(repo),
        calculateUsageUseCase: CalculateUsageUseCase(),
        calculateSpendingUseCase: CalculateSpendingUseCase(),
        generateRecommendationUseCase: GenerateRecommendationUseCase(),
      )..add(const ProfileUsageStarted()),
      child: const ProfileUsagePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.t('profileUsageTitle')),
      ),
      body: BlocBuilder<ProfileUsageBloc, ProfileUsageState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('${context.t('bookingDetailsErrorPrefix')} ${state.error}'));
          }

          final d = state.insight;

          String _planLabel(String plan) {
            if (plan == 'weekly') return context.t('profileUsageWeekly');
            if (plan == 'monthly') return context.t('profileUsageMonthly');
            return context.t('profileUsageDaily');
          }

          String _userType(String type) {
            if (type == 'medium') return context.t('profileUsageMedium');
            if (type == 'long_term') return context.t('profileUsageLongTerm');
            return context.t('profileUsageFlexible');
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _card(
                context,
                title: context.t('profileUsageSummaryCard'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${context.t('profileUsageTotalBookings')}: ${d.totalBookings}'),
                    Text('${context.t('profileUsageDaily')}: ${d.dailyCount}'),
                    Text('${context.t('profileUsageWeekly')}: ${d.weeklyCount}'),
                    Text('${context.t('profileUsageMonthly')}: ${d.monthlyCount}'),
                    Text('${context.t('profileUsageMostUsedPlan')}: ${_planLabel(d.mostUsedPlan)}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                title: context.t('profileUsagePatternCard'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${context.t('profileUsageUserType')}: ${_userType(d.userType)}'),
                    Text(
                      d.repeatsSameSpace
                          ? context.t('profileUsageRepeatsSameSpace')
                          : context.t('profileUsageExploresDifferentSpaces'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                title: context.t('profileUsageSpendingCard'),
                child: Text('${context.t('profileUsageEstimatedSpending')}: ${d.estimatedSpending}₪'),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                title: context.t('profileUsageSavingsCard'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${context.t('profileUsageBestPlan')}: ${_planLabel(d.recommendedPlan)}'),
                    Text('${context.t('profileUsageSavingsAmount')}: ${d.estimatedSavings}₪'),
                    Text('${context.t('profileUsageSavingsMessagePrefix')} ${d.estimatedSavings}₪ ${context.t('profileUsageSavingsMessageSuffix')}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _card(
                context,
                title: context.t('profileUsageOffersSection'),
                child: d.bestOffer == null
                    ? Text(context.t('profileUsageNoOffers'))
                    : ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(d.bestOffer!.offerTitle),
                        subtitle: Text(
                          '${d.bestOffer!.spaceName} • ${context.t('profileUsageBestPlan')}: ${_planLabel(d.bestOffer!.bestPlan)} • ${d.bestOffer!.savings}₪',
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                        onTap: () {
                          final bookingBloc = AppInjector.createBookingBloc();
                          final summary = SpaceSummaryEntity(
                            id: d.bestOffer!.spaceId,
                            name: d.bestOffer!.spaceName,
                            basePricePerDay: d.bestOffer!.basePricePerDay,
                            currency: '₪',
                          );
                          Navigator.of(context).push(
                            BookingRequestRoutes.requestBooking(
                              bloc: bookingBloc,
                              space: summary,
                            ),
                          );
                          bookingBloc.add(
                            OfferChanged(
                              offerId: d.bestOffer!.offerTitle,
                              offerLabel: d.bestOffer!.offerTitle,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, {required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
