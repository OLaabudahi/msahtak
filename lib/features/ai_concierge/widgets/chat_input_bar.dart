import 'package:flutter/material.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
  });

  final ValueChanged<String> onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  static const int _maxMessageLength = 250;
  final _controller = TextEditingController();

  late TextDirection _inputDirection;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.text.isEmpty) {
      _inputDirection = Directionality.of(context);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;
    final nextDirection = _resolveInputDirection(_controller.text);
    setState(() {
      _inputDirection = nextDirection;
    });
  }

  TextDirection _resolveInputDirection(String text) {
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'[A-Za-z]').hasMatch(char)) {
        return TextDirection.ltr;
      }
      if (RegExp(r'[\u0600-\u06FF]').hasMatch(char)) {
        return TextDirection.rtl;
      }
    }
    return Directionality.of(context);
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final count = _controller.text.length;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.inputBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textDirection: _inputDirection,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                maxLength: _maxMessageLength,
                decoration: InputDecoration(
                  hintText: context.t('askAnything'),
                  filled: true,
                  fillColor: AppColors.surface,
                  counterText: '$count/$_maxMessageLength',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _send,
              tooltip: context.t('send'),
              icon: const Icon(Icons.send_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.amber,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
