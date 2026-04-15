import 'package:equatable/equatable.dart';

enum ConciergeSender { bot, user }

class ConciergeMessage extends Equatable {
  final String id;
  final ConciergeSender sender;
  final String text;
  final String? actionSpaceId;

  const ConciergeMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.actionSpaceId,
  });

  bool get hasAction => actionSpaceId != null && actionSpaceId!.isNotEmpty;

  @override
  List<Object?> get props => [id, sender, text, actionSpaceId];
}
