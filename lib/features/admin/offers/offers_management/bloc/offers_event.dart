import 'package:equatable/equatable.dart';
import '../domain/entities/offer_duration_unit.dart';
import '../domain/entities/offer_type.dart';
import '../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';

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

class OffersCreateOpened extends OffersEvent {
  const OffersCreateOpened();
}

class OffersCreateClosed extends OffersEvent {
  const OffersCreateClosed();
}

class OffersCreateFieldChanged extends OffersEvent {
  final String field;
  final String value;
  const OffersCreateFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class OffersCreateTypeChanged extends OffersEvent {
  final OfferType type;
  const OffersCreateTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class OffersCreateDurationUnitChanged extends OffersEvent {
  final OfferDurationUnit unit;
  const OffersCreateDurationUnitChanged(this.unit);
  @override
  List<Object?> get props => [unit];
}

class OffersCreateFixedUnitChanged extends OffersEvent {
  final PriceUnit unit;
  const OffersCreateFixedUnitChanged(this.unit);
  @override
  List<Object?> get props => [unit];
}

class OffersCreatePackageMonthsChanged extends OffersEvent {
  final int months; 
  const OffersCreatePackageMonthsChanged(this.months);
  @override
  List<Object?> get props => [months];
}

class OffersCreateSubmitted extends OffersEvent {
  const OffersCreateSubmitted();
}
