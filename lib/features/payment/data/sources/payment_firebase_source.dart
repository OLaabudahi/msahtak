import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../../core/services/firestore_api.dart';
import '../models/admin_payment_review_model.dart';

class PaymentFirebaseSource {
  final FirestoreApi api;
  static const _supabaseUrl = 'https://fbepuxcsyrerfhzpqvmy.supabase.co';
  static const _supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZiZXB1eGNzeXJlcmZoenBxdm15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzg0MjcsImV4cCI6MjA4ODcxNDQyN30.mNJOsm7RGIaX9OMw1c5R-3O9QV9bixoGc0rZKKecOLk';
  static const _bucket = 'image_masahtak';

  PaymentFirebaseSource(this.api);

  Future<String?> uploadReceipt({
    required String bookingId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ext = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : 'jpg';
      final uploadName = 'receipt-$bookingId-${DateTime.now().millisecondsSinceEpoch}.$ext';
      final uploadUrl = '$_supabaseUrl/storage/v1/object/$_bucket/$uploadName';

      final response = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          'Authorization': 'Bearer $_supabaseKey',
          'Content-Type': 'image/$ext',
        },
        body: bytes,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      return '$_supabaseUrl/storage/v1/object/public/$_bucket/$uploadName';
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSpace(String spaceId) {
    return api.getDoc(collection: 'spaces', docId: spaceId);
  }

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

  Future<Map<String, dynamic>?> getBooking(String bookingId) {
    return api.getDoc(collection: 'bookings', docId: bookingId);
  }
}
