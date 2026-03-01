import 'package:equatable/equatable.dart';

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

class AddEditSpaceAmenityToggled extends AddEditSpaceEvent {
  final String amenityId;
  const AddEditSpaceAmenityToggled(this.amenityId);
  @override
  List<Object?> get props => [amenityId];
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

class AddEditSpaceSavePressed extends AddEditSpaceEvent {
  const AddEditSpaceSavePressed();
}
