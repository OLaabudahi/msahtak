import '../entities/offer_entity.dart';
import '../repos/offers_repo.dart';

class GetOffersUseCase {
  final OffersRepo repo;
  const GetOffersUseCase(this.repo);

  Future<List<OfferEntity>> call() => repo.getOffers();
}
