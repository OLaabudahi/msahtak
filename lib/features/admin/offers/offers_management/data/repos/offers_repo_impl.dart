import '../../domain/entities/offer_entity.dart';
import '../../domain/repos/offers_repo.dart';
import '../models/offer_model.dart';
import '../sources/offers_source.dart';

class OffersRepoImpl implements OffersRepo {
  final OffersSource source;
  const OffersRepoImpl(this.source);

  @override
  Future<List<OfferEntity>> getOffers() async {
    final list = await source.fetchOffers();
    return list.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> toggleOffer({required String offerId, required bool enabled}) {
    return source.toggleOffer(offerId: offerId, enabled: enabled);
  }

  @override
  Future<void> createOffer({required OfferEntity offer}) {
    final m = OfferModel.fromEntity(offer);
    return source.createOffer(offer: m);
  }
}


