import '../../domain/entities/booking_request_entity.dart';

class BookingInMemoryStore {
  BookingInMemoryStore._();
  static final BookingInMemoryStore instance = BookingInMemoryStore._();

  final Map<String, BookingRequestEntity> _requests =
      <String, BookingRequestEntity>{};

  BookingRequestEntity? get(String bookingId) => _requests[bookingId];

  void put(BookingRequestEntity entity) => _requests[entity.bookingId] = entity;

  bool contains(String bookingId) => _requests.containsKey(bookingId);
}


