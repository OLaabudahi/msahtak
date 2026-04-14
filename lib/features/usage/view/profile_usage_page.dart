import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/app_injector.dart';
import '../../../../core/i18n/app_i18n.dart';
import '../../../../theme/app_colors.dart';
import '../../booking_request/bloc/booking_request_event.dart';
import '../../booking_request/domain/entities/booking_request_entity.dart';
import '../../booking_request/view/booking_request_routes.dart';
import '../bloc/profile_usage_bloc.dart';
import '../bloc/profile_usage_event.dart';
import '../bloc/profile_usage_state.dart';
import '../data/repos/profile_usage_repo_firebase.dart';
import '../data/services/profile_usage_firebase_service.dart';
import '../data/sources/profile_usage_source.dart';
import '../domain/entities/usage_insight_entity.dart';
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
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          context.t('usagePageTitle'),
          style: const TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
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
          final totalPlans = d.dailyCount + d.weeklyCount + d.monthlyCount;
          final plans = _buildPlanRows(context: context, insight: d);
          final recommendedPlan = _normalizePlanKey(d.recommendedPlan);
          final mostUsedPlan = _normalizePlanKey(d.mostUsedPlan);
          final selectedPlan = plans.firstWhere(
            (plan) => plan.planKey == recommendedPlan,
            orElse: () => plans.first,
          );
          final savingsLabel = d.estimatedSavings > 0 ? '${d.estimatedSavings}' : '0';

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            children: [
              Text(
                context.t('usageBasedOn'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtext,
                ),
              ),
              const SizedBox(height: 24),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('usageYourUsageCardTitle'), style: _cardTitleStyle),
                    const SizedBox(height: 8),
                    Text(
                      context
                          .t('usageSummaryLine')
                          .replaceAll('{bookings}', '${d.totalBookings}')
                          .replaceAll('{plans}', '$totalPlans')
                          .replaceAll('{avgPlan}', context.t(_planLabelKey(mostUsedPlan))),
                      style: _bodyStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context
                          .t('usageMostCommonPlanLine')
                          .replaceAll('{plan}', context.t(_planLabelKey(mostUsedPlan))),
                      style: _bodyStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('usageInsightsTitle'), style: _cardTitleStyle),
                    const SizedBox(height: 8),
                    Text('• ${_insightLineOne(context, mostUsedPlan)}', style: _bodyStyle),
                    const SizedBox(height: 6),
                    Text('• ${_insightLineTwo(context, d)}', style: _bodyStyle),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text(
                context.t('usagePlanOptimizer'),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.t('usageComparePlans'),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 14),
              _plansContainer(context: context, plans: plans, selectedPlanKey: selectedPlan.planKey),
              const SizedBox(height: 12),
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('usageRecommendation'), style: _cardTitleStyle),
                    const SizedBox(height: 8),
                    Text(
                      context
                          .t('usageRecommendationLine')
                          .replaceAll('{plan}', context.t(_planLabelKey(selectedPlan.planKey)))
                          .replaceAll('{savings}', savingsLabel),
                      style: _bodyStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _bestOfferButton(
                context: context,
                label: context.t('usageViewBestOffer'),
                onPressed: () => _openBestOffer(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  static const TextStyle _cardTitleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.subtext,
    height: 1.25,
  );

  String _normalizePlanKey(String value) {
    final normalized = value.toLowerCase();
    if (normalized == 'week' || normalized == 'weekly') return 'weekly';
    if (normalized == 'month' || normalized == 'monthly') return 'monthly';
    return 'daily';
  }

  String _planLabelKey(String normalizedPlanKey) {
    switch (normalizedPlanKey) {
      case 'weekly':
        return 'profileUsageWeekly';
      case 'monthly':
        return 'profileUsageMonthly';
      default:
        return 'profileUsageDaily';
    }
  }

  String _insightLineOne(BuildContext context, String mostUsedPlan) {
    switch (mostUsedPlan) {
      case 'weekly':
        return context.t('usageInsightWeekly');
      case 'monthly':
        return context.t('usageInsightMonthly');
      default:
        return context.t('usageInsightDaily');
    }
  }

  String _insightLineTwo(BuildContext context, UsageInsightEntity d) {
    if (d.weeklyCount > 0 || d.monthlyCount > 0) {
      return context.t('usageInsightStable');
    }
    return context.t('usageInsightFlexible');
  }

  List<_PlanRowData> _buildPlanRows({
    required BuildContext context,
    required UsageInsightEntity insight,
  }) {
    final pricePerDay = insight.bestOffer?.basePricePerDay ??
        (insight.totalBookings > 0 ? (insight.estimatedSpending / insight.totalBookings).round() : 0);

    return [
      _PlanRowData(
        planKey: 'daily',
        label: context.t('profileUsageDaily'),
        amount: pricePerDay,
        unit: context.t('usagePerDayUnit'),
      ),
      _PlanRowData(
        planKey: 'weekly',
        label: context.t('profileUsageWeekly'),
        amount: pricePerDay * 6,
        unit: context.t('usagePerWeekUnit'),
      ),
      _PlanRowData(
        planKey: 'monthly',
        label: context.t('profileUsageMonthly'),
        amount: pricePerDay * 26,
        unit: context.t('usagePerMonthUnit'),
      ),
    ];
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }

  Widget _plansContainer({
    required BuildContext context,
    required List<_PlanRowData> plans,
    required String selectedPlanKey,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: plans
            .map(
              (plan) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _planRow(
                  context: context,
                  plan: plan,
                  isBest: plan.planKey == selectedPlanKey,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _planRow({
    required BuildContext context,
    required _PlanRowData plan,
    required bool isBest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBest ? AppColors.borderDark : AppColors.borderLight,
          width: isBest ? 1.2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              plan.label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.text),
            ),
          ),
          Text(
            '${plan.amount}₪${plan.unit}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.subtext),
          ),
          if (isBest) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.amber,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                context.t('usageBestBadge'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bestOfferButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnPrimary,
          foregroundColor: AppColors.btnPrimaryText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _openBestOffer(BuildContext context, ProfileUsageState state) {
    final offer = state.insight.bestOffer;
    if (offer == null) return;

    final bookingBloc = AppInjector.createBookingBloc();
    final summary = SpaceSummaryEntity(
      id: offer.spaceId,
      name: offer.spaceName,
      basePricePerDay: offer.basePricePerDay,
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
        offerId: offer.offerTitle,
        offerLabel: offer.offerTitle,
      ),
    );
  }
}

class _PlanRowData {
  final String planKey;
  final String label;
  final int amount;
  final String unit;

  const _PlanRowData({
    required this.planKey,
    required this.label,
    required this.amount,
    required this.unit,
  });
}
