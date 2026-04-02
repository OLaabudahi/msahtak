import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/offer_model.dart';
import 'offers_remote_source.dart';


class OffersFirebaseSource implements OffersRemoteSource {
  @override
  Future<List<OfferModel>> getOffers() async {
    final snap = await FirebaseFirestore.instance
        .collection('offers')
        .limit(30)
        .get();

    if (snap.docs.isNotEmpty) {
      return snap.docs.map(_fromDoc).toList();
    }

    
    return [
      OfferModel(
        id: 'offer_001',
        name: 'Downtown Hub',
        location: 'City Center, Gaza',
        originalPrice: 60,
        discountedPrice: 35,
        discountPercent: 42,
        rating: 4.8,
      ),
      OfferModel(
        id: 'offer_002',
        name: 'Blue Owl Space',
        location: 'Al-Rimal, Gaza',
        originalPrice: 80,
        discountedPrice: 50,
        discountPercent: 38,
        rating: 4.6,
      ),
      OfferModel(
        id: 'offer_003',
        name: 'Study Nest',
        location: 'Sheikh Ajlin, Gaza',
        originalPrice: 50,
        discountedPrice: 30,
        discountPercent: 40,
        rating: 4.7,
      ),
      OfferModel(
        id: 'offer_004',
        name: 'Skyline Desk',
        location: 'Tal Al-Hawa, Gaza',
        originalPrice: 70,
        discountedPrice: 45,
        discountPercent: 36,
        rating: 4.4,
      ),
    ];
  }

  @override
  Future<List<OfferModel>> searchOffers(String query) async {
    final all = await getOffers();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all
        .where((o) =>
            o.name.toLowerCase().contains(q) ||
            o.location.toLowerCase().contains(q))
        .toList();
  }

  OfferModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return OfferModel(
      id: doc.id,
      name: d['name'] as String? ?? d['space_name'] as String? ?? 'Space',
      location: d['location'] as String? ?? '',
      originalPrice: (d['original_price'] as num?)?.toInt() ??
          (d['originalPrice'] as num?)?.toInt() ??
          0,
      discountedPrice: (d['discounted_price'] as num?)?.toInt() ??
          (d['discountedPrice'] as num?)?.toInt() ??
          0,
      discountPercent: (d['discount_percent'] as num?)?.toInt() ??
          (d['discountPercent'] as num?)?.toInt() ??
          0,
      rating: (d['rating'] as num?)?.toDouble() ?? 4.0,
    );
  }
}
