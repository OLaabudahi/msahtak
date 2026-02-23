import '../../domain/entities/offer.dart';
import '../../domain/repos/offers_repo.dart';
import '../sources/offers_remote_source.dart';

class OffersRepoDummy implements OffersRepo {
  final OffersRemoteSource source;
  OffersRepoDummy(this.source);

  /// جلب العروض من المصدر
  @override
  Future<List<Offer>> getOffers() => source.getOffers();

  /// البحث في العروض عبر المصدر
  @override
  Future<List<Offer>> searchOffers(String query) =>
      source.searchOffers(query);
}
