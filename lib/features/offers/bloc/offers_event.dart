import 'package:equatable/equatable.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();
  @override
  List<Object?> get props => [];
}


class OffersStarted extends OffersEvent {
  const OffersStarted();
}


class OffersSearchChanged extends OffersEvent {
  final String query;
  const OffersSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}


class OfferDealPressed extends OffersEvent {
  final String offerId;
  const OfferDealPressed(this.offerId);
  @override
  List<Object?> get props => [offerId];
}
