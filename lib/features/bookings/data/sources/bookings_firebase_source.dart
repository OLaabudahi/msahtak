import '../../../../core/services/firestore_api.dart';
import 'bookings_source.dart';

class BookingsFirebaseSource implements BookingsSource {
  final FirestoreApi api;

  BookingsFirebaseSource(this.api);

  @override
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    return await api.getCollection(collection: "bookings");
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await api.updateFields(
      collection: "bookings",
      docId: bookingId,
      data: {
        "status": "cancelled",
      },
    );
  }
}

