import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PrimaryCtaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryCtaButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(text),
        ),
      ),
    );
  }
}


