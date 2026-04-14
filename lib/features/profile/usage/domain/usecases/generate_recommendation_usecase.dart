import '../entities/usage_booking_entity.dart';
import '../entities/usage_insight_entity.dart';
import '../entities/usage_space_entity.dart';

class GenerateRecommendationResult {
  final String bestPlan;
  final int savings;
  final UsageOfferInsight? offerInsight;

  const GenerateRecommendationResult({
    required this.bestPlan,
    required this.savings,
    required this.offerInsight,
  });
}

class GenerateRecommendationUseCase {
  GenerateRecommendationResult call({
    required List<UsageBookingEntity> bookings,
    required List<UsageSpaceEntity> spaces,
    required String mostUsedPlan,
  }) {
    if (bookings.isEmpty || spaces.isEmpty) {
      return const GenerateRecommendationResult(
        bestPlan: 'daily',
        savings: 0,
        offerInsight: null,
      );
    }

    final bySpace = <String, int>{};
    for (final b in bookings) {
      bySpace.update(b.spaceId, (v) => v + 1, ifAbsent: () => 1);
    }

    final frequentSpaces = bySpace.entries.where((e) => e.value > 1).map((e) => e.key).toSet();
    final spaceMap = {for (final s in spaces) s.id: s};

    var totalSavings = 0;
    UsageOfferInsight? best;

    for (final booking in bookings) {
      if (!frequentSpaces.contains(booking.spaceId)) continue;
      final space = spaceMap[booking.spaceId];
      if (space == null) continue;

      final start = booking.startDate;
      final end = booking.endDate;
      final days = (start != null && end != null)
          ? end.difference(start).inDays.abs() + 1
          : 1;

      final dailyCost = space.pricePerDay * days;
      final weeklyCost = space.pricePerDay * 6;
      final monthlyCost = space.pricePerDay * 26;

      final actual = _actualCost(booking.planType, space.pricePerDay, days);
      final bestCost = [dailyCost, weeklyCost, monthlyCost].reduce((a, b) => a < b ? a : b);
      final saving = actual - bestCost;
      if (saving > 0) {
        totalSavings += saving;
        final recommendedPlan = bestCost == monthlyCost
            ? 'monthly'
            : (bestCost == weeklyCost ? 'weekly' : 'daily');

        final offerTitle = space.offers.isNotEmpty
            ? (space.offers.first['title']?.toString() ?? space.offers.first['badge_text']?.toString() ?? space.name)
            : space.name;

        if (best == null || saving > best.savings) {
          best = UsageOfferInsight(
            spaceId: space.id,
            spaceName: space.name,
            bestPlan: recommendedPlan,
            savings: saving,
            offerTitle: offerTitle,
            basePricePerDay: space.pricePerDay,
          );
        }
      }
    }

    return GenerateRecommendationResult(
      bestPlan: mostUsedPlan,
      savings: totalSavings,
      offerInsight: best,
    );
  }

  int _actualCost(String planType, int pricePerDay, int days) {
    final type = planType.toLowerCase();
    if (type == 'week' || type == 'weekly') return pricePerDay * 6;
    if (type == 'month' || type == 'monthly') return pricePerDay * 26;
    return pricePerDay * days;
  }
}
