import '../entities/offer_entity.dart';
import '../repos/offers_repo.dart';

class CreateOfferUseCase {
  final OffersRepo repo;
  const CreateOfferUseCase(this.repo);

  Future<void> call({required OfferEntity offer}) => repo.createOffer(offer: offer);
}


