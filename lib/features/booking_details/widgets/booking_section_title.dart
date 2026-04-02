import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class BookingSectionTitle extends StatelessWidget {
  final String text;
  const BookingSectionTitle({super.key, required this.text});

  /// âœ… ط¯ط§ظ„ط©: ط¹ظ†ظˆط§ظ† ظ‚ط³ظ… ط¯ط§ط®ظ„ طھظپط§طµظٹظ„ ط§ظ„ط­ط¬ط²
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionTitle);
  }
}


