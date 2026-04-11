import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firestore_api.dart';

class BookingRequestFirebaseSource {
  final FirestoreApi api;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingRequestFirebaseSource(this.api);

  /// =========================
  /// Current User
  /// =========================

  String? get currentUserId => _auth.currentUser?.uid;

  String get currentUserName =>
      _auth.currentUser?.displayName ?? 'User';

  /// =========================
  /// Create Booking
  /// =========================

  Future<void> createBooking({
    required String bookingId,
    required Map<String, dynamic> data,
  }) async {
    await api.create(
      collection: 'bookings',
      docId: bookingId,
      data: data,
    );
  }

  /// =========================
  /// Get Booking
  /// =========================

  Future<Map<String, dynamic>?> getBooking(String bookingId) async {
    return await api.getDoc(
      collection: 'bookings',
      docId: bookingId,
    );
  }

  Future<Map<String, dynamic>?> getSpace(String spaceId) async {
    return await api.getDoc(
      collection: 'spaces',
      docId: spaceId,
    );
  }

  /// =========================
  /// Update Booking
  /// =========================

  Future<void> updateBooking({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await api.updateFields(
      collection: 'bookings',
      docId: id,
      data: data,
    );
  }
}
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/firestore_api.dart';

class BookingRequestFirebaseSource {
  final FirestoreApi api;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingRequestFirebaseSource(this.api);

  /// بيانات المستخدم
  String? get currentUserId => _auth.currentUser?.uid;
  String get currentUserName =>
      _auth.currentUser?.displayName ?? 'User';

  /// إنشاء الحجز
  Future<String> createBooking({
    required Map<String, dynamic> data,
  }) async {
    final docRef =
    FirebaseFirestore.instance.collection('bookings').doc();

    await api.create(
      collection: 'bookings',
      docId: docRef.id,
      data: data,
    );

    return docRef.id;
  }

  /// جلب الحجز
  Future<Map<String, dynamic>?> getBooking(String id) {
    return api.getDoc(collection: 'bookings', docId: id);
  }

  /// تحديث الحجز
  Future<void> updateBooking({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return api.updateFields(
      collection: 'bookings',
      docId: id,
      data: data,
    );
  }
}*/
