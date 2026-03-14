import '../../domain/entities/booking_request_entity.dart';

class BookingInMemoryStore {
  BookingInMemoryStore._();
  static final BookingInMemoryStore instance = BookingInMemoryStore._();

  final Map<String, BookingRequestEntity> _requests =
      <String, BookingRequestEntity>{};

  BookingRequestEntity? get(String requestId) => _requests[requestId];

  void put(BookingRequestEntity entity) => _requests[entity.requestId] = entity;

  bool contains(String requestId) => _requests.containsKey(requestId);
}
