import 'dart:async';

import '../../../../core/services/firestore_api.dart';
import '../../../../services/auth_service.dart';
import 'bookings_source.dart';

class BookingsFirebaseSource implements BookingsSource {
  final FirestoreApi api;
  final AuthService authService;

  BookingsFirebaseSource({
    required this.api,
    required this.authService,
  });

  String? get _uid {
    final uid = authService.currentUser?.uid;
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final uid = _uid;
    if (uid == null) return const [];

    final byUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'userId',
      value: uid,
      limit: 300,
    );

    final byLegacyUserId = await api.queryWhereEqual(
      collection: 'bookings',
      field: 'user_id',
      value: uid,
      limit: 300,
    );

    return _mergeAndFilter(uid: uid, rows: [...byUserId, ...byLegacyUserId]);
  }

  @override
  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    final uid = _uid;
    if (uid == null) return null;

    final row = await api.getDocInCollection(collection: 'bookings', docId: bookingId);
    if (row == null) return null;

    final ownerA = (row['userId'] ?? '').toString();
    final ownerB = (row['user_id'] ?? '').toString();

    if (ownerA != uid && ownerB != uid) {
      return null;
    }

    return row;
  }

  @override
  Future<Map<String, dynamic>?> getSpaceById(String spaceId) {
    return api.getDocInCollection(collection: 'spaces', docId: spaceId);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: {
        'status': 'cancelled',
      },
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listenBookingsUpdates() {
    final uid = _uid;
    if (uid == null) return Stream.value(const []);

    final byUserId = api.streamWhereEqual(
      collection: 'bookings',
      field: 'userId',
      value: uid,
      limit: 300,
    );

    final byLegacyUserId = api.streamWhereEqual(
      collection: 'bookings',
      field: 'user_id',
      value: uid,
      limit: 300,
    );

    final controller = StreamController<List<Map<String, dynamic>>>();

    List<Map<String, dynamic>> latestByUserId = const [];
    List<Map<String, dynamic>> latestByLegacy = const [];

    void pushMerged() {
      controller.add(
        _mergeAndFilter(uid: uid, rows: [...latestByUserId, ...latestByLegacy]),
      );
    }

    final subA = byUserId.listen((event) {
      latestByUserId = event;
      pushMerged();
    });

    final subB = byLegacyUserId.listen((event) {
      latestByLegacy = event;
      pushMerged();
    });

    controller.onCancel = () async {
      await subA.cancel();
      await subB.cancel();
    };

    return controller.stream;
  }

  List<Map<String, dynamic>> _mergeAndFilter({
    required String uid,
    required List<Map<String, dynamic>> rows,
  }) {
    final merged = <String, Map<String, dynamic>>{};

    for (final row in rows) {
      final id = (row['id'] ?? '').toString();
      if (id.isEmpty) continue;

      final ownerA = (row['userId'] ?? '').toString();
      final ownerB = (row['user_id'] ?? '').toString();
      if (ownerA != uid && ownerB != uid) continue;

      merged[id] = row;
    }

    return merged.values.toList(growable: false);
  }
}
