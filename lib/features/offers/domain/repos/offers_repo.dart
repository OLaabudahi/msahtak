import '../entities/offer.dart';

abstract class OffersRepo {
  /// جلب جميع العروض
  Future<List<Offer>> getOffers();

  /// البحث في العروض بالنص
  Future<List<Offer>> searchOffers(String query);
}
