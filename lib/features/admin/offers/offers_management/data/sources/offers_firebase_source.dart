import 'package:cloud_firestore/cloud_firestore.dart';
import 'offers_source.dart';
import '../models/offer_model.dart';

/// ظ…طµط¯ط± Firebase ظ„ظ„ط¹ط±ظˆط¶ â€” ظٹظ‚ط±ط£/ظٹظƒطھط¨ ظ…ظ† offers collection
class OffersFirebaseSource implements OffersSource {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<OfferModel>> fetchOffers() async {
    final snap = await _db.collection('offers').get();
    return snap.docs.map((doc) {
      final d = doc.data();
      d['id'] = doc.id;
      return OfferModel.fromJson(d);
    }).toList();
  }

  @override
  Future<void> toggleOffer({required String offerId, required bool enabled}) async {
    await _db.collection('offers').doc(offerId).update({'enabled': enabled});
  }

  @override
  Future<void> createOffer({required OfferModel offer}) async {
    final data = offer.toJson();
    data.remove('id');
    await _db.collection('offers').add(data);
  }
}


