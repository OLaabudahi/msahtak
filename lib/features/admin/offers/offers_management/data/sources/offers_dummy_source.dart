import 'offers_source.dart';
import '../models/offer_model.dart';

class OffersDummySource implements OffersSource {
  final List<OfferModel> _offers = [
    const OfferModel(id: 'o1', title: 'Student Week', percent: '15%', duration: '7 days', terms: 'Valid for students only', enabled: true),
    const OfferModel(id: 'o2', title: 'New Space Promo', percent: '10%', duration: '14 days', terms: 'First booking only', enabled: false),
  ];

  @override
  Future<List<OfferModel>> fetchOffers() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return List<OfferModel>.from(_offers);
  }

  @override
  Future<void> toggleOffer({required String offerId, required bool enabled}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (var i = 0; i < _offers.length; i++) {
      if (_offers[i].id == offerId) {
        _offers[i] = OfferModel(
          id: _offers[i].id,
          title: _offers[i].title,
          percent: _offers[i].percent,
          duration: _offers[i].duration,
          terms: _offers[i].terms,
          enabled: enabled,
        );
      }
    }
  }

  @override
  Future<void> createOffer({required OfferModel offer}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    _offers.insert(0, offer);
  }
}
