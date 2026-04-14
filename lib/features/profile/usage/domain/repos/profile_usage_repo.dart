import '../entities/usage_booking_entity.dart';
import '../entities/usage_space_entity.dart';

abstract class ProfileUsageRepo {
  Future<List<UsageBookingEntity>> getUserBookings();
  Future<List<UsageSpaceEntity>> getSpacesByIds(List<String> ids);
}
