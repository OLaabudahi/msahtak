import 'admin_booking_details_source.dart';
import '../models/booking_details_model.dart';

class AdminBookingDetailsDummySource implements AdminBookingDetailsSource {
  @override
  Future<BookingDetailsModel> fetchBookingDetails({required String bookingId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return BookingDetailsModel(
      id: bookingId,
      bookingCode: 'BK-2026-001',
      userName: 'Sarah Johnson',
      userAvatar: 'SJ',
      userPhone: '+1 (555) 123-4567',
      userEmail: 'sarah.johnson@email.com',
      space: 'Downtown Hub',
      spaceAddress: '123 Main St, City Center',
      date: 'Feb 28, 2026',
      time: '10:00 AM - 2:00 PM',
      duration: '4 hours',
      plan: 'Hot Desk',
      price: '\$50/hour',
      total: '\$200',
      status: 'pending',
    );
  }

  @override
  Future<void> confirmBooking({required String bookingId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
  }

  @override
  Future<void> cancelBooking({required String bookingId, required String reason}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
  }
}
