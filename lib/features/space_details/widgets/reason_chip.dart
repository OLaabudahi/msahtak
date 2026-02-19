import 'package:flutter/material.dart';

class ReasonChip extends StatelessWidget {
  final String text;
  const ReasonChip({super.key, required this.text});

  /// ✅ دالة: Chip رمادي مثل "Why people come here"
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}
