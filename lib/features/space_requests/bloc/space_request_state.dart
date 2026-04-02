abstract class SpaceRequestState {}

class SpaceRequestInitial extends SpaceRequestState {}

class SpaceRequestLoading extends SpaceRequestState {}

class SpaceRequestSuccess extends SpaceRequestState {}

class SpaceRequestError extends SpaceRequestState {
  final String message;

  SpaceRequestError(this.message);
}

