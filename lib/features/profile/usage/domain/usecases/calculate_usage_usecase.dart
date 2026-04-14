import '../entities/usage_booking_entity.dart';

class CalculateUsageResult {
  final int totalBookings;
  final int dailyCount;
  final int weeklyCount;
  final int monthlyCount;
  final String mostUsedPlan;
  final String favoriteSpaceId;
  final String userType;
  final bool repeatsSameSpace;

  const CalculateUsageResult({
    required this.totalBookings,
    required this.dailyCount,
    required this.weeklyCount,
    required this.monthlyCount,
    required this.mostUsedPlan,
    required this.favoriteSpaceId,
    required this.userType,
    required this.repeatsSameSpace,
  });
}

class CalculateUsageUseCase {
  CalculateUsageResult call(List<UsageBookingEntity> bookings) {
    if (bookings.isEmpty) {
      return const CalculateUsageResult(
        totalBookings: 0,
        dailyCount: 0,
        weeklyCount: 0,
        monthlyCount: 0,
        mostUsedPlan: 'daily',
        favoriteSpaceId: '',
        userType: 'flexible',
        repeatsSameSpace: false,
      );
    }

    int daily = 0;
    int weekly = 0;
    int monthly = 0;
    final bySpace = <String, int>{};

    for (final booking in bookings) {
      final type = booking.planType.toLowerCase();
      if (type == 'week' || type == 'weekly') {
        weekly++;
      } else if (type == 'month' || type == 'monthly') {
        monthly++;
      } else {
        daily++;
      }
      bySpace.update(booking.spaceId, (v) => v + 1, ifAbsent: () => 1);
    }

    String mostPlan = 'daily';
    if (weekly >= daily && weekly >= monthly) {
      mostPlan = 'weekly';
    }
    if (monthly >= daily && monthly >= weekly) {
      mostPlan = 'monthly';
    }

    String userType = 'flexible';
    if (mostPlan == 'weekly') userType = 'medium';
    if (mostPlan == 'monthly') userType = 'long_term';

    String favoriteSpaceId = '';
    int maxCount = -1;
    bySpace.forEach((spaceId, count) {
      if (count > maxCount) {
        maxCount = count;
        favoriteSpaceId = spaceId;
      }
    });

    final repeatsSameSpace = bySpace.length < bookings.length;

    return CalculateUsageResult(
      totalBookings: bookings.length,
      dailyCount: daily,
      weeklyCount: weekly,
      monthlyCount: monthly,
      mostUsedPlan: mostPlan,
      favoriteSpaceId: favoriteSpaceId,
      userType: userType,
      repeatsSameSpace: repeatsSameSpace,
    );
  }
}
