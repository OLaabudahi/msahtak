import 'package:equatable/equatable.dart';

enum ConciergeSender { bot, user }

class ConciergeMessage extends Equatable {
  final String id;
  final ConciergeSender sender;
  final String text;
  final String? actionSpaceId;
  final String? actionSpaceName;
  final List<ConciergeAction> actions;

  const ConciergeMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.actionSpaceId,
    this.actionSpaceName,
    this.actions = const [],
  });

  bool get hasAction =>
      actions.isNotEmpty || (actionSpaceId != null && actionSpaceId!.isNotEmpty);

  @override
  List<Object?> get props => [id, sender, text, actionSpaceId, actionSpaceName, actions];
}

class ConciergeAction extends Equatable {
  final String spaceId;
  final String? spaceName;

  const ConciergeAction({
    required this.spaceId,
    this.spaceName,
  });

  @override
  List<Object?> get props => [spaceId, spaceName];
}
