import '../models/offer_model.dart';


abstract class OffersRemoteSource {
  Future<List<OfferModel>> getOffers();
  Future<List<OfferModel>> searchOffers(String query);
}

class FakeOffersSource implements OffersRemoteSource {
  static const _allOffers = [
    OfferModel(
      id: '1',
      name: 'Downtown Hub',
      location: 'City Center â€¢ Quiet',
      originalPrice: 60,
      discountedPrice: 45,
      discountPercent: 25,
      rating: 4.8,
    ),
    OfferModel(
      id: '2',
      name: 'Creative Zone',
      location: 'West Side â€¢ Cozy',
      originalPrice: 50,
      discountedPrice: 35,
      discountPercent: 30,
      rating: 4.6,
    ),
    OfferModel(
      id: '3',
      name: 'City Study Room',
      location: 'City Center â€¢ Silent',
      originalPrice: 40,
      discountedPrice: 28,
      discountPercent: 30,
      rating: 4.5,
    ),
  ];

  
  @override
  Future<List<OfferModel>> getOffers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _allOffers;
  }

  
  @override
  Future<List<OfferModel>> searchOffers(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return _allOffers;
    final q = query.toLowerCase();
    return _allOffers
        .where((o) =>
            o.name.toLowerCase().contains(q) ||
            o.location.toLowerCase().contains(q))
        .toList();
  }
}
