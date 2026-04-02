import 'package:Msahtak/features/bookings/data/models/booking_model.dart';

import '../repos/bookings_repo.dart';

class GetBookingsUseCase {
  final BookingsRepo repo;

  GetBookingsUseCase(this.repo);

  Future<List<Booking>> call() {
    return repo.fetchBookings();
  }
}

