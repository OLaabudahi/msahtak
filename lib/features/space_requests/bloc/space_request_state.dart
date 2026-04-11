import 'package:equatable/equatable.dart';

abstract class SpaceRequestState extends Equatable {
  const SpaceRequestState();

  @override
  List<Object?> get props => [];
}

class SpaceRequestInitial extends SpaceRequestState {
  const SpaceRequestInitial();
}

class SpaceRequestLoading extends SpaceRequestState {
  const SpaceRequestLoading();
}

class SpaceRequestSuccess extends SpaceRequestState {
  const SpaceRequestSuccess();
}

class SpaceRequestError extends SpaceRequestState {
  final String message;

  const SpaceRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
