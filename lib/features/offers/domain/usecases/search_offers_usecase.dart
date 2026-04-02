import '../entities/offer.dart';
import '../repos/offers_repo.dart';

class SearchOffersUseCase {
  final OffersRepo repo;
  SearchOffersUseCase(this.repo);

  
  Future<List<Offer>> call(String query) => repo.searchOffers(query);
}
