import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String text;
  const SettingsSectionTitle({super.key, required this.text});

  /// ✅ عنوان قسم في صفحة الإعدادات
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
      ),
    );
  }
}
