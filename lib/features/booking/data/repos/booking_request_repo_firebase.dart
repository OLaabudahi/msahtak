import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';
import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';

/// ✅ تنفيذ Firebase لـ BookingRequestRepo — يحفظ الحجوزات في Firestore
class BookingRequestRepoFirebase implements BookingRequestRepo {
  final _db = FirebaseFirestore.instance;

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    final int days = _toDays(durationUnit, durationValue);
    final int spaceSubtotal = space.basePricePerDay * days;
    final int offerDiscount = _calcOfferDiscount(spaceSubtotal, offerId);
    final int addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);
    final int total = (spaceSubtotal - offerDiscount + addOnsTotal).clamp(0, double.maxFinite).toInt();

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total,
      currency: space.currency,
    );
  }

  @override
  Future<BookingRequestEntity> createRequest({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? purposeId,
    required String? purposeLabel,
    required String? offerId,
    required String? offerLabel,
    required List<AddOnEntity> addOns,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'User';

    final quoteEntity = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );

    final endDate = startDate.add(Duration(days: _toDays(durationUnit, durationValue)));

    // حفظ الحجز في Firestore
    final docRef = await _db.collection('bookings').add({
      'userId': uid,
      'userName': userName,
      'spaceId': space.id,
      'spaceName': space.name,
      'workspaceId': space.id,
      'workspaceName': space.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'durationUnit': durationUnit.name,
      'durationValue': durationValue,
      'purposeId': purposeId,
      'purposeLabel': purposeLabel,
      'offerId': offerId,
      'offerLabel': offerLabel,
      'totalAmount': quoteEntity.total,
      'currency': space.currency,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return BookingRequestModel(
      requestId: docRef.id,
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      purposeId: purposeId,
      purposeLabel: purposeLabel,
      offerId: offerId,
      offerLabel: offerLabel,
      addOns: addOns,
      status: BookingRequestStatus.pending,
      statusHint: 'Usually responds within 1–2 hours',
      totalAmount: quoteEntity.total,
      currency: quoteEntity.currency,
      bookingId: docRef.id,
    );
  }

  @override
  Future<BookingRequestEntity> getStatus({required String requestId}) async {
    final doc = await _db.collection('bookings').doc(requestId).get();
    return _docToEntity(doc);
  }

  @override
  Future<BookingRequestEntity> refreshStatus({required String requestId}) async {
    final doc = await _db.collection('bookings').doc(requestId).get();
    return _docToEntity(doc);
  }

  @override
  Future<BookingRequestEntity> cancel({required String requestId}) async {
    await _db.collection('bookings').doc(requestId).update({
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    final doc = await _db.collection('bookings').doc(requestId).get();
    return _docToEntity(doc);
  }

  BookingRequestEntity _docToEntity(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final statusRaw = d['status'] as String? ?? 'pending';
    final status = _parseStatus(statusRaw);
    final startTs = d['startDate'] as Timestamp?;

    return BookingRequestModel(
      requestId: doc.id,
      space: SpaceSummaryEntity(
        id: d['spaceId'] as String? ?? d['workspaceId'] as String? ?? '',
        name: d['spaceName'] as String? ?? d['workspaceName'] as String? ?? 'Space',
        basePricePerDay: (d['totalAmount'] as num?)?.toInt() ?? 0,
        currency: d['currency'] as String? ?? '₪',
      ),
      startDate: startTs?.toDate() ?? DateTime.now(),
      durationUnit: DurationUnit.days,
      durationValue: d['durationValue'] as int? ?? 1,
      purposeId: d['purposeId'] as String?,
      purposeLabel: d['purposeLabel'] as String?,
      offerId: d['offerId'] as String?,
      offerLabel: d['offerLabel'] as String?,
      addOns: const [],
      status: status,
      statusHint: _statusHint(status),
      totalAmount: (d['totalAmount'] as num?)?.toInt() ?? 0,
      currency: d['currency'] as String? ?? '₪',
      bookingId: doc.id,
    );
  }

  BookingRequestStatus _parseStatus(String raw) {
    switch (raw.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return BookingRequestStatus.approved;
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return BookingRequestStatus.cancelled;
      default:
        return BookingRequestStatus.pending;
    }
  }

  String _statusHint(BookingRequestStatus status) {
    switch (status) {
      case BookingRequestStatus.approved:
        return 'Your booking is confirmed!';
      case BookingRequestStatus.cancelled:
        return 'Booking was cancelled';
      default:
        return 'Usually responds within 1–2 hours';
    }
  }

  int _toDays(DurationUnit unit, int value) {
    switch (unit) {
      case DurationUnit.days:
        return value;
      case DurationUnit.weeks:
        return value * 7;
      case DurationUnit.months:
        return value * 30;
    }
  }

  int _calcOfferDiscount(int subtotal, String? offerId) {
    if (offerId == null) return 0;
    if (offerId == 'WEEKLY') return (subtotal * 0.10).round();
    if (offerId == 'MONTHLY') return (subtotal * 0.15).round();
    return (subtotal * 0.05).round();
  }
}
