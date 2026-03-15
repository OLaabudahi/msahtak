import 'package:equatable/equatable.dart';
import '../domain/entities/price_unit.dart';
import '../domain/entities/week_day.dart';

sealed class AddEditSpaceEvent extends Equatable {
  const AddEditSpaceEvent();
  @override
  List<Object?> get props => [];
}

class AddEditSpaceStarted extends AddEditSpaceEvent {
  final String? spaceId;
  const AddEditSpaceStarted(this.spaceId);
  @override
  List<Object?> get props => [spaceId];
}

class AddEditSpaceFieldChanged extends AddEditSpaceEvent {
  final String field;
  final String value;
  const AddEditSpaceFieldChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class AddEditSpaceHiddenToggled extends AddEditSpaceEvent {
  final bool hidden;
  const AddEditSpaceHiddenToggled(this.hidden);
  @override
  List<Object?> get props => [hidden];
}

class AddEditSpaceBasePriceChanged extends AddEditSpaceEvent {
  final String value; // keep string in UI then parse in bloc
  const AddEditSpaceBasePriceChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEditSpaceBaseUnitChanged extends AddEditSpaceEvent {
  final PriceUnit unit;
  const AddEditSpaceBaseUnitChanged(this.unit);
  @override
  List<Object?> get props => [unit];
}

class AddEditSpaceLocationSet extends AddEditSpaceEvent {
  final double lat;
  final double lng;
  const AddEditSpaceLocationSet(this.lat, this.lng);
  @override
  List<Object?> get props => [lat, lng];
}

class AddEditSpaceAmenityCatalogRequested extends AddEditSpaceEvent {
  const AddEditSpaceAmenityCatalogRequested();
}

class AddEditSpaceAmenityToggled extends AddEditSpaceEvent {
  final String amenityId;
  const AddEditSpaceAmenityToggled(this.amenityId);
  @override
  List<Object?> get props => [amenityId];
}

class AddEditSpaceAmenityAddRequested extends AddEditSpaceEvent {
  final String name;
  const AddEditSpaceAmenityAddRequested(this.name);
  @override
  List<Object?> get props => [name];
}

class AddEditSpaceWorkingDayEnabledToggled extends AddEditSpaceEvent {
  final WeekDay day;
  final bool enabled; // enabled means not closed and exists
  const AddEditSpaceWorkingDayEnabledToggled(this.day, this.enabled);
  @override
  List<Object?> get props => [day, enabled];
}

class AddEditSpaceWorkingDayClosedToggled extends AddEditSpaceEvent {
  final WeekDay day;
  final bool closed;
  const AddEditSpaceWorkingDayClosedToggled(this.day, this.closed);
  @override
  List<Object?> get props => [day, closed];
}

class AddEditSpaceWorkingTimeChanged extends AddEditSpaceEvent {
  final WeekDay day;
  final String open;  // HH:mm
  final String close; // HH:mm
  const AddEditSpaceWorkingTimeChanged(this.day, this.open, this.close);
  @override
  List<Object?> get props => [day, open, close];
}

class AddEditSpacePolicySectionAdded extends AddEditSpaceEvent {
  const AddEditSpacePolicySectionAdded();
}

class AddEditSpacePolicySectionRemoved extends AddEditSpaceEvent {
  final String sectionId;
  const AddEditSpacePolicySectionRemoved(this.sectionId);
  @override
  List<Object?> get props => [sectionId];
}

class AddEditSpacePolicySectionTitleChanged extends AddEditSpaceEvent {
  final String sectionId;
  final String title;
  const AddEditSpacePolicySectionTitleChanged(this.sectionId, this.title);
  @override
  List<Object?> get props => [sectionId, title];
}

class AddEditSpacePolicyBulletAdded extends AddEditSpaceEvent {
  final String sectionId;
  final String text;
  const AddEditSpacePolicyBulletAdded(this.sectionId, this.text);
  @override
  List<Object?> get props => [sectionId, text];
}

class AddEditSpacePolicyBulletRemoved extends AddEditSpaceEvent {
  final String sectionId;
  final int index;
  const AddEditSpacePolicyBulletRemoved(this.sectionId, this.index);
  @override
  List<Object?> get props => [sectionId, index];
}

class AddEditSpaceSavePressed extends AddEditSpaceEvent {
  const AddEditSpaceSavePressed();
}


class AddEditSpaceImageAdded extends AddEditSpaceEvent {
  final String url;
  const AddEditSpaceImageAdded(this.url);
  @override
  List<Object?> get props => [url];
}

class AddEditSpaceImageRemoved extends AddEditSpaceEvent {
  final int index;
  const AddEditSpaceImageRemoved(this.index);
  @override
  List<Object?> get props => [index];
}

class AddEditSpaceSeatsChanged extends AddEditSpaceEvent {
  final String value;
  const AddEditSpaceSeatsChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEditSpaceAdminChanged extends AddEditSpaceEvent {
  final String? adminId;
  final String? adminName;
  const AddEditSpaceAdminChanged({this.adminId, this.adminName});
  @override
  List<Object?> get props => [adminId, adminName];
}
