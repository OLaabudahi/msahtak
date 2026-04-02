import 'package:flutter/material.dart';

class AdminPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color background;
  final Widget? leading;

  const AdminPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.background = const Color(0xFF5682AF),
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

