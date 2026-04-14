import 'package:equatable/equatable.dart';

abstract class SavedSpacesEvent extends Equatable {
  const SavedSpacesEvent();

  @override
  List<Object?> get props => [];
}

class SavedSpacesStarted extends SavedSpacesEvent {
  const SavedSpacesStarted();
}
