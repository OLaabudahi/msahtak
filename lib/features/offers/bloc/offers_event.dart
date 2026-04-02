import 'package:equatable/equatable.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل العروض عند فتح الصفحة
class OffersStarted extends OffersEvent {
  const OffersStarted();
}

/// تحديث نص البحث
class OffersSearchChanged extends OffersEvent {
  final String query;
  const OffersSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

/// الضغط على زر Deal لعرض تفاصيل العرض
class OfferDealPressed extends OffersEvent {
  final String offerId;
  const OfferDealPressed(this.offerId);
  @override
  List<Object?> get props => [offerId];
}
