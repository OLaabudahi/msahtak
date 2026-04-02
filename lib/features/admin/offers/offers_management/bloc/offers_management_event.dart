import 'package:equatable/equatable.dart';
import '../domain/entities/offer_duration_unit.dart';
import '../domain/entities/offer_type.dart';
import '../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';

sealed class OffersManagementEvent extends Equatable {
  const OffersManagementEvent();
  @override
  List<Object?> get props => [];
}

class OffersManagementStarted extends OffersManagementEvent {
  const OffersManagementStarted();
}

class OffersManagementTogglePressed extends OffersManagementEvent {
  final String offerId;
  final bool enabled;
  const OffersManagementTogglePressed(this.offerId, this.enabled);
  @override
  List<Object?> get props => [offerId, enabled];
}

class OffersManagementCreateOpened extends OffersManagementEvent {
  const OffersManagementCreateOpened();
}

class OffersManagementCreateClosed extends OffersManagementEvent {
  const OffersManagementCreateClosed();
}

class OffersManagementCreateFieldChanged extends OffersManagementEvent {
  final String field;
  final String value;
  const OffersManagementCreateFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class OffersManagementCreateTypeChanged extends OffersManagementEvent {
  final OfferType type;
  const OffersManagementCreateTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class OffersManagementCreateDurationUnitChanged extends OffersManagementEvent {
  final OfferDurationUnit unit;
  const OffersManagementCreateDurationUnitChanged(this.unit);
  @override
  List<Object?> get props => [unit];
}

class OffersManagementCreateFixedUnitChanged extends OffersManagementEvent {
  final PriceUnit unit;
  const OffersManagementCreateFixedUnitChanged(this.unit);
  @override
  List<Object?> get props => [unit];
}

class OffersManagementCreatePackageMonthsChanged extends OffersManagementEvent {
  final int months; 
  const OffersManagementCreatePackageMonthsChanged(this.months);
  @override
  List<Object?> get props => [months];
}

class OffersManagementCreateSubmitted extends OffersManagementEvent {
  const OffersManagementCreateSubmitted();
}


