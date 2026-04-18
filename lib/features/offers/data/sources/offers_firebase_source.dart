import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/offer_model.dart';
import 'offers_remote_source.dart';

/// ✅ تنفيذ Firebase لـ OffersRemoteSource
class OffersFirebaseSource implements OffersRemoteSource {
  static const int _weeklyExtraDiscountPercent = 5;

  @override
  Future<List<OfferModel>> getOffers() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || userId.isEmpty) return const [];

    final bookedSpaceIds = await _getBookedSpaceIds(userId);
    if (bookedSpaceIds.isEmpty) return const [];

    final snap = await FirebaseFirestore.instance.collection('offers').limit(30).get();

    final offers = snap.docs.isNotEmpty
        ? snap.docs.map(_fromDoc).toList(growable: false)
        : _fallbackOffers();

    final eligible = offers.where((offer) => bookedSpaceIds.contains(offer.id)).toList();

    return eligible.map(_applyMsahtakUserDiscount).toList(growable: false);
  }

  @override
  Future<List<OfferModel>> searchOffers(String query) async {
    final all = await getOffers();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all
        .where((o) => o.name.toLowerCase().contains(q) || o.location.toLowerCase().contains(q))
        .toList(growable: false);
  }

  Future<Set<String>> _getBookedSpaceIds(String userId) async {
    final db = FirebaseFirestore.instance;

    final byUserId = await db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .limit(400)
        .get();
    final byLegacyUserId = await db
        .collection('bookings')
        .where('user_id', isEqualTo: userId)
        .limit(400)
        .get();

    final ids = <String>{};
    for (final doc in [...byUserId.docs, ...byLegacyUserId.docs]) {
      final data = doc.data();
      final spaceId = (data['spaceId'] ?? data['space_id'] ?? data['workspaceId'] ?? '').toString();
      if (spaceId.isNotEmpty) ids.add(spaceId);
    }
    return ids;
  }

  OfferModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final spaceId = (d['spaceId'] ?? d['space_id'] ?? d['workspaceId'] ?? doc.id).toString();
    return OfferModel(
      id: spaceId,
      name: d['name'] as String? ?? d['space_name'] as String? ?? 'Space',
      location: d['location'] as String? ?? '',
      originalPrice: (d['original_price'] as num?)?.toInt() ??
          (d['originalPrice'] as num?)?.toInt() ??
          (d['pricePerDay'] as num?)?.toInt() ??
          0,
      discountedPrice: (d['discounted_price'] as num?)?.toInt() ??
          (d['discountedPrice'] as num?)?.toInt() ??
          (d['offerPrice'] as num?)?.toInt() ??
          0,
      discountPercent: (d['discount_percent'] as num?)?.toInt() ??
          (d['discountPercent'] as num?)?.toInt() ??
          0,
      rating: (d['rating'] as num?)?.toDouble() ?? 4.0,
      discountLabel: (d['discountLabel'] ?? '').toString(),
    );
  }

  OfferModel _applyMsahtakUserDiscount(OfferModel offer) {
    final discountedWithExtra = (offer.discountedPrice * (100 - _weeklyExtraDiscountPercent) / 100).round();
    final pct = offer.originalPrice > 0
        ? ((1 - (discountedWithExtra / offer.originalPrice)) * 100).round()
        : offer.discountPercent;

    return OfferModel(
      id: offer.id,
      name: offer.name,
      location: offer.location,
      originalPrice: offer.originalPrice,
      discountedPrice: discountedWithExtra,
      discountPercent: pct,
      rating: offer.rating,
      discountLabel: 'خصم مستخدم مساحتك',
    );
  }

  List<OfferModel> _fallbackOffers() {
    return const [
      OfferModel(
        id: 'SPACE-001',
        name: 'Downtown Hub',
        location: 'City Center, Gaza',
        originalPrice: 60,
        discountedPrice: 35,
        discountPercent: 42,
        rating: 4.8,
      ),
      OfferModel(
        id: 'SPACE-002',
        name: 'Blue Owl Space',
        location: 'Al-Rimal, Gaza',
        originalPrice: 80,
        discountedPrice: 50,
        discountPercent: 38,
        rating: 4.6,
      ),
    ];
  }
}
