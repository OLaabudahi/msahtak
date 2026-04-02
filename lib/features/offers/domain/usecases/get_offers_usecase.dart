import '../entities/offer.dart';
import '../repos/offers_repo.dart';

class GetOffersUseCase {
  final OffersRepo repo;
  GetOffersUseCase(this.repo);

  /// جلب قائمة العروض كاملة
  Future<List<Offer>> call() => repo.getOffers();
}
