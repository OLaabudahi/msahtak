import '../models/offer_model.dart';

abstract class OffersSource {
  Future<List<OfferModel>> fetchOffers();
  Future<void> toggleOffer({required String offerId, required bool enabled});
  Future<void> createOffer({required OfferModel offer});
}


