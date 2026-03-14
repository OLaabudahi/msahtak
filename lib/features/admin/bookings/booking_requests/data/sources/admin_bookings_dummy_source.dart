import 'admin_bookings_source.dart';
import '../models/booking_request_model.dart';

class AdminBookingsDummySource implements AdminBookingsSource {
  final List<BookingRequestModel> _all = [
    const BookingRequestModel(id: 'b1', userName: 'Sarah Johnson', userAvatar: 'SJ', date: 'Feb 28, 2026', time: '10:00 AM - 2:00 PM', duration: '4 hours', plan: 'Hot Desk', space: 'Downtown Hub', status: 'pending'),
    const BookingRequestModel(id: 'b2', userName: 'Mike Chen', userAvatar: 'MC', date: 'Feb 28, 2026', time: '2:00 PM - 6:00 PM', duration: '4 hours', plan: 'Private Office', space: 'Creative Studio', status: 'pending'),
    const BookingRequestModel(id: 'b3', userName: 'Emily Brown', userAvatar: 'EB', date: 'Mar 1, 2026', time: '9:00 AM - 5:00 PM', duration: '8 hours', plan: 'Meeting Room', space: 'Tech Center', status: 'pending'),
    const BookingRequestModel(id: 'b4', userName: 'John Smith', userAvatar: 'JS', date: 'Feb 27, 2026', time: '10:00 AM - 4:00 PM', duration: '6 hours', plan: 'Hot Desk', space: 'Downtown Hub', status: 'approved'),
    const BookingRequestModel(id: 'b5', userName: 'Lisa Anderson', userAvatar: 'LA', date: 'Feb 26, 2026', time: '1:00 PM - 5:00 PM', duration: '4 hours', plan: 'Private Office', space: 'City Office', status: 'canceled'),
  ];

  @override
  Future<List<BookingRequestModel>> fetchBookings({required String status}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return _all.where((e) => e.status == status).toList(growable: false);
  }

  @override
  Future<void> acceptBooking({required String bookingId}) async => Future<void>.delayed(const Duration(milliseconds: 120));

  @override
  Future<void> rejectBooking({required String bookingId}) async => Future<void>.delayed(const Duration(milliseconds: 120));
}
