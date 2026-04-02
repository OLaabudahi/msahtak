import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/services/firestore_api.dart';
import '../models/admin_payment_review_model.dart';

class PaymentFirebaseSource {
  final FirestoreApi api;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PaymentFirebaseSource(this.api);

  /// =========================
  /// Upload Receipt
  /// =========================
  Future<String?> uploadReceipt({
    required String bookingId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ext = fileName.split('.').last;

      final ref = _storage.ref().child(
        'receipts/$bookingId-${DateTime.now().millisecondsSinceEpoch}.$ext',
      );

      await ref.putData(bytes);

      return await ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  /// =========================
  /// Get Space
  /// =========================
  Future<Map<String, dynamic>?> getSpace(String spaceId) {
    return api.getDoc(collection: 'spaces', docId: spaceId);
  }

  /// =========================
  /// Submit Payment
  /// =========================
  Future<void> submitPayment({
    required String bookingId,
    required Map<String, dynamic> data,
  }) async {
    await api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: data,
    );
  }

  /// =========================
  /// Create Admin Review (WITH ID ًں”¥)
  /// =========================
  Future<void> createAdminReview({
    required String reviewId,
    required AdminPaymentReviewModel review,
  }) async {
    await api.create(
      collection: 'paymentReviews',
      docId: reviewId,
      data: review.toJson(),
    );
  }

  /// =========================
  /// Get Booking
  /// =========================
  Future<Map<String, dynamic>?> getBooking(String bookingId) {
    return api.getDoc(collection: 'bookings', docId: bookingId);
  }
}
/*
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/services/firestore_api.dart';
import '../models/admin_payment_review_model.dart';

class PaymentFirebaseSource {
  final FirestoreApi api;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PaymentFirebaseSource(this.api);

  /// ط±ظپط¹ طµظˆط±ط© ط§ظ„ط¥ظٹطµط§ظ„
  Future<String?> uploadReceipt({
    required String bookingId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ext = fileName.split('.').last;
      final ref = _storage.ref().child(
        'receipts/$bookingId-${DateTime.now().millisecondsSinceEpoch}.$ext',
      );

      await ref.putData(bytes);

      return await ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSpace(String spaceId) {
    return api.getDoc(collection: 'spaces', docId: spaceId);
  }

  /// طھط­ط¯ظٹط« ط§ظ„ط¯ظپط¹ ط¯ط§ط®ظ„ Firestore
  Future<void> submitPayment({
    required String bookingId,
    required Map<String, dynamic> data,
  }) async {
    await api.updateFields(
      collection: 'bookings',
      docId: bookingId,
      data: data,
    );
  }
  /// ط¥ط¶ط§ظپط© ط·ظ„ط¨ ظ…ط±ط§ط¬ط¹ط© ظ„ظ„ط£ط¯ظ…ظ†
  Future<void> createAdminReview({
    required AdminPaymentReviewModel review,
  }) async {
    await FirebaseFirestore.instance
        .collection('paymentReviews')
        .add(review.toJson());
  }

  /// ط¬ظ„ط¨ ط¨ظٹط§ظ†ط§طھ ط§ظ„ط­ط¬ط²
  Future<Map<String, dynamic>?> getBooking(String bookingId) {
    return api.getDoc(collection: 'bookings', docId: bookingId);
  }

}

*/


