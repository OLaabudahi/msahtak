import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/services/firestore_api.dart';
import '../models/admin_payment_review_model.dart';

class PaymentFirebaseSource {
  final FirestoreApi api;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PaymentFirebaseSource(this.api);

  /// رفع صورة الإيصال
  Future<String?> uploadReceipt({
    required String requestId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ext = fileName.split('.').last;
      final ref = _storage.ref().child(
        'receipts/$requestId-${DateTime.now().millisecondsSinceEpoch}.$ext',
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

  /// تحديث الدفع داخل Firestore
  Future<void> submitPayment({
    required String requestId,
    required Map<String, dynamic> data,
  }) async {
    await api.updateFields(
      collection: 'bookings',
      docId: requestId,
      data: data,
    );
  }
  /// إضافة طلب مراجعة للأدمن
  Future<void> createAdminReview({
    required AdminPaymentReviewModel review,
  }) async {
    await FirebaseFirestore.instance
        .collection('paymentReviews')
        .add(review.toJson());
  }

  /// جلب بيانات الحجز
  Future<Map<String, dynamic>?> getBooking(String requestId) {
    return api.getDoc(collection: 'bookings', docId: requestId);
  }

}

