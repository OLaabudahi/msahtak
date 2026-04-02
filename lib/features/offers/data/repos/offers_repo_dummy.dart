import '../../domain/entities/offer.dart';
import '../../domain/repos/offers_repo.dart';
import '../sources/offers_remote_source.dart';

class OffersRepoDummy implements OffersRepo {
  final OffersRemoteSource source;
  OffersRepoDummy(this.source);

  /// ط¬ظ„ط¨ ط§ظ„ط¹ط±ظˆط¶ ظ…ظ† ط§ظ„ظ…طµط¯ط±
  @override
  Future<List<Offer>> getOffers() => source.getOffers();

  /// ط§ظ„ط¨ط­ط« ظپظٹ ط§ظ„ط¹ط±ظˆط¶ ط¹ط¨ط± ط§ظ„ظ…طµط¯ط±
  @override
  Future<List<Offer>> searchOffers(String query) =>
      source.searchOffers(query);
}


