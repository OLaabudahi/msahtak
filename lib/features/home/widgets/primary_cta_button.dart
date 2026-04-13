import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';

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
    return AppButton(
      label: text,
      onPressed: onPressed,
      width: double.infinity,
      borderRadius: 24,
    );
  }
}

