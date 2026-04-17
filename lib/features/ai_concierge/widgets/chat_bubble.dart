import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/concierge_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.onActionTap,
  });

  final ConciergeMessage message;
  final ValueChanged<String> onActionTap;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ConciergeSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? AppColors.amber : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isUser ? AppColors.amber : AppColors.inputBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.text.isNotEmpty)
                Text(
                  message.text,
                  style: TextStyle(
                    color: isUser ? Colors.black : AppColors.text,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              if (message.hasAction) ...[
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => onActionTap(message.actionSpaceId!),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: Colors.black,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text(
                    ' ${[message.text.split('\n').isNotEmpty ? message.text.split('\n').first : '']} ${context.t('bookNow')}',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
