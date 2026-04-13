import '../../../../core/services/firestore_api.dart';
import 'booking_details_source.dart';

class BookingDetailsFirebaseSource implements BookingDetailsSource {
  final FirestoreApi firestoreApi;

  BookingDetailsFirebaseSource(this.firestoreApi);

  @override
  Future<Map<String, dynamic>?> getBookingById(String bookingId) {
    return firestoreApi.getDocInCollection(collection: 'bookings', docId: bookingId);
  }

  @override
  Future<Map<String, dynamic>?> getSpaceById(String spaceId) {
    if (spaceId.isEmpty) return Future.value(null);
    return firestoreApi.getDocInCollection(collection: 'spaces', docId: spaceId);
  }

  @override
  Future<void> cancelBooking(String bookingId) {
    return firestoreApi.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': 'cancelled',
      },
    );
  }

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) {
    return firestoreApi.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': status,
      },
    );
  }
}
