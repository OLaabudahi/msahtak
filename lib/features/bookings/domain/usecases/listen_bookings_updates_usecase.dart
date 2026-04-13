import '../../data/models/booking_model.dart';
import '../repos/bookings_repo.dart';

class ListenBookingsUpdatesUseCase {
  final BookingsRepo repo;

  ListenBookingsUpdatesUseCase(this.repo);

  Stream<List<BookingModel>> call() {
    return repo.listenBookingsUpdates();
  }
}
