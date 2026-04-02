import '../models/offer_model.dart';

/// ظˆط§ط¬ظ‡ط© ظ…طµط¯ط± ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ FakeOffersSource ط¨ظ€ RealOffersSource ط¹ظ†ط¯ ط±ط¨ط· API
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

  /// ط¬ظ„ط¨ ط¬ظ…ظٹط¹ ط§ظ„ط¹ط±ظˆط¶ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/offers') ط¹ظ†ط¯ ط±ط¨ط· API
  @override
  Future<List<OfferModel>> getOffers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _allOffers;
  }

  /// ط§ظ„ط¨ط­ط« ظ…ط­ظ„ظٹط§ظ‹ ظپظٹ ط§ظ„ط¨ظٹط§ظ†ط§طھ â€“ ط§ط³طھط¨ط¯ظ„ ط¨ظ€ http.get('/offers?q=query') ط¹ظ†ط¯ ط±ط¨ط· API
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


