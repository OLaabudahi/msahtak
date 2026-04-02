import '../entities/offer.dart';

abstract class OffersRepo {
  /// ط¬ظ„ط¨ ط¬ظ…ظٹط¹ ط§ظ„ط¹ط±ظˆط¶
  Future<List<Offer>> getOffers();

  /// ط§ظ„ط¨ط­ط« ظپظٹ ط§ظ„ط¹ط±ظˆط¶ ط¨ط§ظ„ظ†طµ
  Future<List<Offer>> searchOffers(String query);
}


