import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  final String title;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: title,
      onPressed: onPressed,
      loading: loading,
      width: double.infinity,
      height: 48,
      borderRadius: 24,
    );
  }
}

