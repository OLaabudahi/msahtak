import 'package:equatable/equatable.dart';

import 'concierge_message.dart';

class ConciergeReply extends Equatable {
  const ConciergeReply({
    required this.message,
    required this.currentSpaces,
  });

  final ConciergeMessage message;
  final List<Map<String, dynamic>> currentSpaces;

  @override
  List<Object?> get props => [message, currentSpaces];
}
