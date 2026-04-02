import '../entities/offer.dart';

abstract class OffersRepo {
  
  Future<List<Offer>> getOffers();

  
  Future<List<Offer>> searchOffers(String query);
}
