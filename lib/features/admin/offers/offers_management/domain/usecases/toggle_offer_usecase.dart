import '../repos/offers_repo.dart';

class ToggleOfferUseCase {
  final OffersRepo repo;
  const ToggleOfferUseCase(this.repo);

  Future<void> call({required String offerId, required bool enabled}) => repo.toggleOffer(offerId: offerId, enabled: enabled);
}


