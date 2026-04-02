import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String text;
  const SettingsSectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


