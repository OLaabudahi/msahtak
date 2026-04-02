import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repos/bookings_repo.dart';
import '../models/booking_model.dart';

/// ✅ تنفيذ Firebase لـ BookingsRepo – يقرأ bookings مرتبطة بالمستخدم
class BookingsRepoFirebase implements BookingsRepo {
  @override
  Future<List<BookingModel>> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    // الأدمن يكتب userId (camelCase) ، التطبيق القديم كان user_id
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .get();
    } catch (_) {
      snap = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user_id', isEqualTo: uid)
          .get();
    }

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snap.docs;

    // إذا لم نجد بـ userId نجرب user_id
    if (docs.isEmpty) {
      try {
        final snap2 = await FirebaseFirestore.instance
            .collection('bookings')
            .where('user_id', isEqualTo: uid)
            .get();
        docs = snap2.docs;
      } catch (_) {}
    }

    docs.sort((a, b) {
      // الأدمن يكتب createdAt ، التطبيق القديم created_at
      final aTs = a.data()['createdAt'] ?? a.data()['created_at'];
      final bTs = b.data()['createdAt'] ?? b.data()['created_at'];
      if (aTs is Timestamp && bTs is Timestamp) return bTs.compareTo(aTs);
      return 0;
    });

    // جمع كل spaceIds الفريدة لجلب صور الأماكن
    final spaceIds = docs
        .map((doc) {
          final d = doc.data();
          return d['space_id'] as String? ??
              d['spaceId'] as String? ??
              '';
        })
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();


    final Map<String, String> spaceImages = {};
    if (spaceIds.isNotEmpty) {
      final futures = await Future.wait([
        ...spaceIds.map((id) => FirebaseFirestore.instance.collection('spaces').doc(id).get()),
      ]);
      for (final snap in futures) {
        if (!snap.exists) continue;
        final d = snap.data()!;
        final imagesList = (d['images'] as List?)?.cast<String>() ?? const [];
        final url = imagesList.isNotEmpty
            ? imagesList.first
            : (d['imageUrl'] as String? ??
                d['cover'] as String? ??
                d['thumbnailUrl'] as String? ??
                '');
        if (url.isNotEmpty) spaceImages[snap.id] = url;
      }
    }

    return docs.map((doc) {
      final d = doc.data();

      // الأدمن يكتب workspaceId ، التطبيق القديم space_id
      final spaceId = d['space_id'] as String? ??
          d['spaceId'] as String? ??
          '';

      // الأدمن لا يكتب space_name – نستخدم workspaceId كـ fallback
      final spaceName = d['space_name'] as String? ??
          d['spaceName'] as String? ??
          'Space';

      // التاريخ: الأدمن يكتب startDate كـ Timestamp
      final startTs = d['startDate'] as Timestamp? ?? d['date'] as Timestamp?;
      final dateText = d['date_text'] as String? ??
          d['date'] as String? ??
          (startTs != null
              ? '${startTs.toDate().day}/${startTs.toDate().month}/${startTs.toDate().year}'
              : '--');

      final endTs = d['endDate'] as Timestamp?;
      final timeText = d['time_text'] as String? ??
          d['time_slot'] as String? ??
          (startTs != null && endTs != null
              ? '${_fmt(startTs.toDate())} – ${_fmt(endTs.toDate())}'
              : '--');

      // السعر: الأدمن يكتب totalAmount
      final totalPrice = (d['total_price'] as num?)?.toDouble() ??
          (d['totalPrice'] as num?)?.toDouble() ??
          (d['totalAmount'] as num?)?.toDouble() ??
          0.0;

      // الصورة: من الحجز أولاً، ثم من بيانات المكان
      final imageUrl = d['image_url'] as String? ??
          d['imageUrl'] as String? ??
          spaceImages[spaceId];

      return BookingModel(
        bookingId: doc.id,
        spaceId: spaceId,
        spaceName: spaceName,
        dateText: dateText,
        timeText: timeText,
        status: _normalizeStatus(d['status'] as String?),
        totalPrice: totalPrice,
        currency: d['currency'] as String? ?? '₪',
        imageUrl: imageUrl,
      );
    }).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  /// تحويل حالات Firebase إلى القيم المتوقعة في التطبيق
  String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return 'confirmed';
      case 'pending':
      case 'under_review':
        return 'upcoming';
      case 'rejected':
      case 'denied':
      case 'cancelled':
        return 'cancelled';
      case 'completed':
        return 'completed';
      default:
        return 'upcoming';
    }
  }
}
