import '../entities/offer.dart';
import '../repos/offers_repo.dart';

class GetOffersUseCase {
  final OffersRepo repo;
  GetOffersUseCase(this.repo);

  /// ط¬ظ„ط¨ ظ‚ط§ط¦ظ…ط© ط§ظ„ط¹ط±ظˆط¶ ظƒط§ظ…ظ„ط©
  Future<List<Offer>> call() => repo.getOffers();
}


