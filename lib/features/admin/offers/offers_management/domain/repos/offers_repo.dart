import '../entities/offer_entity.dart';

abstract class OffersRepo {
  Future<List<OfferEntity>> getOffers();
  Future<void> toggleOffer({required String offerId, required bool enabled});
  Future<void> createOffer({required OfferEntity offer});
}


