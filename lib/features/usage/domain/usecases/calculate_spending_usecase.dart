import '../entities/usage_booking_entity.dart';
import '../entities/usage_space_entity.dart';

class CalculateSpendingUseCase {
  int call({
    required List<UsageBookingEntity> bookings,
    required List<UsageSpaceEntity> spaces,
  }) {
    final spaceMap = {for (final s in spaces) s.id: s};
    var total = 0;

    for (final booking in bookings) {
      final space = spaceMap[booking.spaceId];
      if (space == null) continue;

      final type = booking.planType.toLowerCase();
      if (type == 'week' || type == 'weekly') {
        total += space.pricePerDay * 6;
      } else if (type == 'month' || type == 'monthly') {
        total += space.pricePerDay * 26;
      } else {
        final start = booking.startDate;
        final end = booking.endDate;
        final days = (start != null && end != null)
            ? end.difference(start).inDays.abs() + 1
            : 1;
        total += space.pricePerDay * days;
      }
    }

    return total;
  }
}
