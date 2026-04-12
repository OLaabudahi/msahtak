import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';

import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';
import '../sources/booking_request_firebase_source.dart';

class BookingRequestRepoFirebase implements BookingRequestRepo {
  final BookingRequestFirebaseSource source;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  BookingRequestRepoFirebase({required this.source});

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    final days = _toDays(durationUnit, durationValue);

    final spaceSubtotal = space.basePricePerDay * days;

    final offerDiscount = await _calcOfferDiscount(
      space: space,
      subtotal: spaceSubtotal,
      offerId: offerId,
      days: days,
    );

    final addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);

    final total =
    (spaceSubtotal - offerDiscount + addOnsTotal).clamp(0, 999999999);

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total.toInt(),
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
    final userId = source.currentUserId;
    final userName = source.currentUserName;

    final bookingId =
        "BID-${DateTime.now().millisecondsSinceEpoch}";

    final quoteResult = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );
    final spaceDoc = await source.getSpace(space.id);
    final spaceAdminId = spaceDoc?['adminId'] as String?;

    final endDate =
    startDate.add(Duration(days: _toDays(durationUnit, durationValue)));

    /// Build the model from incoming entity + pricing snapshot.
    final model = BookingRequestModel(
      bookingId: bookingId,
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
      statusHint: 'Pending approval',
      totalAmount: quoteResult.total,
      currency: quoteResult.currency,
    );

    /// Merge extra fields before persisting.
    final modelMap = model.toMap();
    final currentSpace =
        (modelMap['space'] as Map<String, dynamic>? ?? <String, dynamic>{});

    final data = {
      ...modelMap,
      'space': {
        ...currentSpace,
        'adminId': spaceAdminId,
      },
      'userId': userId,
      'userName': userName,
      // kept for query/index compatibility across existing admin/user screens.
      'spaceId': space.id,
      'spaceName': space.name,
      'adminId': spaceAdminId,
      'endDate': endDate,
      'createdAt': DateTime.now(),
    };

    /// Persist via Firebase source.
    await source.createBooking(
      bookingId: bookingId,
      data: data,
    );

    await _notifyNewBookingStakeholders(
      bookingId: bookingId,
      spaceId: space.id,
      spaceName: space.name,
      ownerAdminId: spaceAdminId,
      requesterName: userName,
    );

    return model;
  }

  @override
  Future<BookingRequestEntity> getStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
  }

  @override
  Future<BookingRequestEntity> refreshStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
  }

  @override
  Future<BookingRequestEntity> cancel({
    required String bookingId,
    required String reason,
  }) async {
    final before = await source.getBooking(bookingId);
    final prevStatus = (before?['status'] ?? '').toString();
    await source.updateBooking(
      id: bookingId,
      data: {
        'status': 'cancelled',
        'statusHint': 'Cancelled by user: $reason',
        'cancelReason': reason,
        'cancellationStage': _resolveUserCancellationStage(prevStatus),
        'cancelledBy': {
          'role': 'user',
          'uid': source.currentUserId,
          'name': source.currentUserName,
        },
        'cancelledAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      },
    );

    await _notifySuperAdminsOnStatusChange(
      bookingId: bookingId,
      newStatus: 'cancelled',
      actorRole: 'user',
      actorName: source.currentUserName,
      actorId: source.currentUserId,
    );

    final data = await source.getBooking(bookingId);

    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromMap(data);
  }

  String _resolveUserCancellationStage(String prevStatus) {
    if (prevStatus == 'approved_waiting_payment' || prevStatus == 'approved') {
      return 'before_payment';
    }
    if (prevStatus == 'payment_under_review' ||
        prevStatus == 'confirmed' ||
        prevStatus == 'paid') {
      return 'after_payment';
    }
    return 'request_stage';
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

  Future<int> _calcOfferDiscount({
    required SpaceSummaryEntity space,
    required int subtotal,
    required String? offerId,
    required int days,
  }) async {
    if (offerId == null || offerId.isEmpty) return 0;

    final spaceDoc = await source.getSpace(space.id);
    final rawOffers = (spaceDoc?['offers'] as List?) ?? const [];

    Map<String, dynamic>? offer;
    for (final item in rawOffers) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      final id = (map['id'] ?? '').toString().trim().toLowerCase();
      if (id == offerId.trim().toLowerCase()) {
        offer = map;
        break;
      }
    }
    if (offer == null) return 0;

    final discountPercent = _asDouble(offer['discountPercent']);
    if (discountPercent != null && discountPercent > 0) {
      return (subtotal * (discountPercent / 100)).round();
    }

    final discountValue = _asDouble(offer['discountValue']);
    if (discountValue != null && discountValue > 0) {
      final value = discountValue.round();
      return value > subtotal ? subtotal : value;
    }

    final newPriceValue =
        _asDouble(offer['new_price_value']) ?? _extractFirstNumber(offer['new_price_text']?.toString());
    if (newPriceValue == null || newPriceValue <= 0) return 0;

    final periodDays = _inferOfferPeriodDays(offer);
    if (periodDays <= 0) return 0;

    final bundles = days ~/ periodDays;
    final remainderDays = days % periodDays;

    final offerTotal = (bundles * newPriceValue) + (remainderDays * space.basePricePerDay);
    final discount = (subtotal - offerTotal).round();
    if (discount <= 0) return 0;
    return discount > subtotal ? subtotal : discount;
  }

  int _inferOfferPeriodDays(Map<String, dynamic> offer) {
    final id = (offer['id'] ?? '').toString().toLowerCase();
    final title = (offer['title'] ?? '').toString().toLowerCase();
    final text = (offer['new_price_text'] ?? '').toString().toLowerCase();
    final combined = '$id $title $text';

    if (combined.contains('month')) return 30;
    if (combined.contains('week')) return 7;
    if (combined.contains('day')) return 1;
    return 7;
  }

  double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  double? _extractFirstNumber(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)').firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }

  Future<void> _notifyNewBookingStakeholders({
    required String bookingId,
    required String spaceId,
    required String spaceName,
    required String? ownerAdminId,
    required String requesterName,
  }) async {
    final recipients = <String>{};

    if (ownerAdminId != null && ownerAdminId.isNotEmpty) {
      recipients.add(ownerAdminId);
    }

    final superAdmins = await _db
        .collection('users')
        .where('role', isEqualTo: 'super_admin')
        .get();
    for (final doc in superAdmins.docs) {
      recipients.add(doc.id);
    }

    final subAdmins = await _db
        .collection('users')
        .where('role', whereIn: ['sup_admin', 'sub_admin'])
        .get();
    for (final doc in subAdmins.docs) {
      final assigned = (doc.data()['assignedSpaceIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[];
      if (assigned.contains(spaceId)) {
        recipients.add(doc.id);
      }
    }

    final batch = _db.batch();
    for (final uid in recipients) {
      final ref = _db.collection('notifications').doc();
      batch.set(ref, {
        'userId': uid,
        'title': 'New Booking Request',
        'subtitle': '$requesterName requested booking at $spaceName',
        'type': 'tip',
        'requestId': bookingId,
        'bookingId': bookingId,
        'spaceId': spaceId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    if (recipients.isNotEmpty) {
      await batch.commit();
    }
  }

  Future<void> _notifySuperAdminsOnStatusChange({
    required String bookingId,
    required String newStatus,
    required String actorRole,
    required String actorName,
    required String? actorId,
  }) async {
    final supers = await _db
        .collection('users')
        .where('role', isEqualTo: 'super_admin')
        .get();

    if (supers.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in supers.docs) {
      final ref = _db.collection('notifications').doc();
      batch.set(ref, {
        'userId': doc.id,
        'title': 'Booking status changed',
        'subtitle': '$actorName ($actorRole) changed booking $bookingId to $newStatus',
        'type': 'tip',
        'requestId': bookingId,
        'bookingId': bookingId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
        'changedBy': {
          'uid': actorId,
          'name': actorName,
          'role': actorRole,
        },
      });
    }
    await batch.commit();
  }
}
/*
import '../../domain/entities/booking_price_quote_entity.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../domain/repos/booking_request_repo.dart';
import '../models/booking_price_quote_model.dart';
import '../models/booking_request_model.dart';
import '../sources/booking_request_firebase_source.dart';

class BookingRequestRepoFirebase implements BookingRequestRepo {
  final BookingRequestFirebaseSource source;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  BookingRequestRepoFirebase({required this.source});

  @override
  Future<BookingPriceQuoteEntity> quote({
    required SpaceSummaryEntity space,
    required DateTime startDate,
    required DurationUnit durationUnit,
    required int durationValue,
    required String? offerId,
    required List<AddOnEntity> addOns,
  }) async {
    final days = _toDays(durationUnit, durationValue);

    final spaceSubtotal = space.basePricePerDay * days;

    final offerDiscount = await _calcOfferDiscount(
      space: space,
      subtotal: spaceSubtotal,
      offerId: offerId,
      days: days,
    );

    final addOnsTotal = addOns
        .where((a) => a.isSelected)
        .fold<int>(0, (sum, a) => sum + a.price);

    final total =
    (spaceSubtotal - offerDiscount + addOnsTotal).clamp(0, 999999999);

    return BookingPriceQuoteModel(
      spaceSubtotal: spaceSubtotal,
      offerDiscount: offerDiscount,
      addOnsTotal: addOnsTotal,
      total: total.toInt(),
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
    final userId = source.currentUserId;
    final userName = source.currentUserName;

    final quoteResult = await quote(
      space: space,
      startDate: startDate,
      durationUnit: durationUnit,
      durationValue: durationValue,
      offerId: offerId,
      addOns: addOns,
    );

    final endDate =
    startDate.add(Duration(days: _toDays(durationUnit, durationValue)));

    final data = {
      'userId': userId,
      'userName': userName,
      'spaceId': space.id,
      'spaceName': space.name,
      'startDate': startDate,
      'endDate': endDate,
      'durationUnit': durationUnit.name,
      'durationValue': durationValue,
      'purposeId': purposeId,
      'purposeLabel': purposeLabel,
      'offerId': offerId,
      'offerLabel': offerLabel,
      'totalPrice': quoteResult.total,
      'currency': space.currency,
      'status': 'pending',
      'createdAt': DateTime.now(),
    };

    final id = await source.createBooking(data: data);

    return BookingRequestModel(
      bookingId: id,
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
      statusHint: 'Pending approval',
      totalAmount: quoteResult.total,
      currency: quoteResult.currency,
      bookingId: id,
    );
  }

  @override
  Future<BookingRequestEntity> getStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);
    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromJson(data);
  }

  @override
  Future<BookingRequestEntity> refreshStatus({
    required String bookingId,
  }) async {
    final data = await source.getBooking(bookingId);
    if (data == null) throw Exception('Booking not found');

    return BookingRequestModel.fromJson(data);
  }

  @override
  Future<BookingRequestEntity> cancel({
    required String bookingId,
  }) async {
    await source.updateBooking(
      id: bookingId,
      data: {'status': 'cancelled'},
    );

    final data = await source.getBooking(bookingId);
    return BookingRequestModel.fromJson(data!);
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
}*/
