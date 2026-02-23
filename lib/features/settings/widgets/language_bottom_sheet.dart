import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LanguageBottomSheet extends StatelessWidget {
  final String selected; // "en" / "ar"
  final ValueChanged<String> onSelect;

  const LanguageBottomSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _accent = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose language',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 14),
            _LangRow(
              title: 'English',
              code: 'en',
              selected: selected,
              onTap: () {
                onSelect('en');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _LangRow(
              title: 'Arabic',
              code: 'ar',
              selected: selected,
              onTap: () {
                onSelect('ar');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangRow extends StatelessWidget {
  final String title;
  final String code;
  final String selected;
  final VoidCallback onTap;

  const _LangRow({
    required this.title,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  static const _accent = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    final isSelected = code == selected;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _accent.withOpacity(isSelected ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: _accent),
          ],
        ),
      ),
    );
  }
}
