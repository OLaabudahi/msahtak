import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/concierge_message.dart';

class ChatBubble extends StatelessWidget {
  final ConciergeMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ConciergeSender.user;

    final bg = isUser ? AppColors.amber : AppColors.secondary;
    final fg = isUser ? Colors.black : Colors.white;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

