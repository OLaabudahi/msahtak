import 'offers_source.dart';
import '../models/offer_model.dart';

class OffersDummySource implements OffersSource {
  final List<OfferModel> _offers = [
    // Fixed price override example: ₪25/day until Sep 30
    const OfferModel(
      id: 'o1',
      title: 'Morning Focus Deal',
      type: 'fixedPriceOverride',
      validUntil: 'Sep 30',
      enabled: true,
      durationValue: null,
      durationUnit: null,
      discountPercent: null,
      fixedPriceValue: 25,
      fixedPriceUnit: 'day',
      packageMonths: null,
      packageDiscountPercent: null,
      fixedMonthlyPrice: null,
      bonusText: null,
    ),

    // Bonus example
    const OfferModel(
      id: 'o2',
      title: 'Free Meeting Room Hour',
      type: 'bonus',
      validUntil: 'Oct 10',
      enabled: true,
      durationValue: null,
      durationUnit: null,
      discountPercent: null,
      fixedPriceValue: null,
      fixedPriceUnit: null,
      packageMonths: null,
      packageDiscountPercent: null,
      fixedMonthlyPrice: null,
      bonusText: '+ 1 hour free (with day booking)',
    ),

    // Package months example (3/6/9/12)
    const OfferModel(
      id: 'o3',
      title: '3 Months Package',
      type: 'packageMonths',
      validUntil: 'Dec 31',
      enabled: false,
      durationValue: null,
      durationUnit: null,
      discountPercent: null,
      fixedPriceValue: null,
      fixedPriceUnit: null,
      packageMonths: 3,
      packageDiscountPercent: 10,
      fixedMonthlyPrice: null,
      bonusText: null,
    ),

    // Discount percent example
    const OfferModel(
      id: 'o4',
      title: 'Student Week',
      type: 'discountPercent',
      validUntil: 'Nov 01',
      enabled: true,
      durationValue: 7,
      durationUnit: 'days',
      discountPercent: 15,
      fixedPriceValue: null,
      fixedPriceUnit: null,
      packageMonths: null,
      packageDiscountPercent: null,
      fixedMonthlyPrice: null,
      bonusText: null,
    ),
  ];

  @override
  Future<List<OfferModel>> fetchOffers() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return List<OfferModel>.from(_offers);
  }

  @override
  Future<void> toggleOffer({required String offerId, required bool enabled}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (var i = 0; i < _offers.length; i++) {
      if (_offers[i].id == offerId) {
        _offers[i] = OfferModel(
          id: _offers[i].id,
          title: _offers[i].title,
          type: _offers[i].type,
          validUntil: _offers[i].validUntil,
          enabled: enabled,
          durationValue: _offers[i].durationValue,
          durationUnit: _offers[i].durationUnit,
          discountPercent: _offers[i].discountPercent,
          fixedPriceValue: _offers[i].fixedPriceValue,
          fixedPriceUnit: _offers[i].fixedPriceUnit,
          packageMonths: _offers[i].packageMonths,
          packageDiscountPercent: _offers[i].packageDiscountPercent,
          fixedMonthlyPrice: _offers[i].fixedMonthlyPrice,
          bonusText: _offers[i].bonusText,
        );
      }
    }
  }

  @override
  Future<void> createOffer({required OfferModel offer}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    _offers.insert(0, offer);
  }
}
