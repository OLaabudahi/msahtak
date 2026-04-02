import 'package:equatable/equatable.dart';

enum ConciergeSender { bot, user }

class ConciergeMessage extends Equatable {
  final String id;
  final ConciergeSender sender;
  final String text;

  const ConciergeMessage({
    required this.id,
    required this.sender,
    required this.text,
  });

  @override
  List<Object?> get props => [id, sender, text];
}

