import 'package:equatable/equatable.dart';

sealed class OffersEvent extends Equatable {
  const OffersEvent();
  @override
  List<Object?> get props => [];
}

class OffersStarted extends OffersEvent {
  const OffersStarted();
}

class OffersTogglePressed extends OffersEvent {
  final String offerId;
  final bool enabled;
  const OffersTogglePressed(this.offerId, this.enabled);
  @override
  List<Object?> get props => [offerId, enabled];
}

class OffersCreatePressed extends OffersEvent {
  final String title;
  final String percent;
  final String duration;
  final String terms;
  final bool enabled;
  const OffersCreatePressed(this.title, this.percent, this.duration, this.terms, this.enabled);
  @override
  List<Object?> get props => [title, percent, duration, terms, enabled];
}
