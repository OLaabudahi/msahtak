import 'package:equatable/equatable.dart';

import '../domain/entities/space_request_entity.dart';

abstract class SpaceRequestEvent extends Equatable {
  const SpaceRequestEvent();

  @override
  List<Object?> get props => [];
}

class SubmitSpaceRequestEvent extends SpaceRequestEvent {
  final SpaceRequestEntity request;

  const SubmitSpaceRequestEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class ResetSpaceRequestEvent extends SpaceRequestEvent {
  const ResetSpaceRequestEvent();
}
