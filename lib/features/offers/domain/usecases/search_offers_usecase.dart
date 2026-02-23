import '../entities/offer.dart';
import '../repos/offers_repo.dart';

class SearchOffersUseCase {
  final OffersRepo repo;
  SearchOffersUseCase(this.repo);

  /// البحث عن عروض بناءً على نص معين
  Future<List<Offer>> call(String query) => repo.searchOffers(query);
}
