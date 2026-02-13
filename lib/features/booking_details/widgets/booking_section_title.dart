import 'package:flutter/material.dart';
import '../../../theme/app_text_styles.dart';

class BookingSectionTitle extends StatelessWidget {
  final String text;
  const BookingSectionTitle({super.key, required this.text});

  /// ✅ دالة: عنوان قسم داخل تفاصيل الحجز
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionTitle);
  }
}
