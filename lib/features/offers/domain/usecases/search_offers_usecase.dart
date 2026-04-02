import '../entities/offer.dart';
import '../repos/offers_repo.dart';

class SearchOffersUseCase {
  final OffersRepo repo;
  SearchOffersUseCase(this.repo);

  /// ط§ظ„ط¨ط­ط« ط¹ظ† ط¹ط±ظˆط¶ ط¨ظ†ط§ط،ظ‹ ط¹ظ„ظ‰ ظ†طµ ظ…ط¹ظٹظ†
  Future<List<Offer>> call(String query) => repo.searchOffers(query);
}


