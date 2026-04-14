import '../entities/usage_booking_entity.dart';
import '../repos/profile_usage_repo.dart';

class GetUserBookingsUseCase {
  final ProfileUsageRepo repo;
  GetUserBookingsUseCase(this.repo);

  Future<List<UsageBookingEntity>> call() => repo.getUserBookings();
}
