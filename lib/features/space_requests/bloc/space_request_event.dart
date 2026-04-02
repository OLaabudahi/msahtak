abstract class SpaceRequestEvent {}

class SubmitSpaceRequestEvent extends SpaceRequestEvent {
  final Map<String, dynamic> data;

  SubmitSpaceRequestEvent(this.data);

}
class ResetSpaceRequestEvent extends SpaceRequestEvent {

}

