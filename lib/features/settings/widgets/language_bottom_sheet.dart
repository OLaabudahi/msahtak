import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatelessWidget {
  final String selected; // "en" / "ar"
  final ValueChanged<String> onSelect;

  const LanguageBottomSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  /// ✅ BottomSheet لاختيار اللغة
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
            const Text('Choose language', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
                style: FilledButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder()),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w900)),
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

  /// ✅ عنصر اختيار لغة
  @override
  Widget build(BuildContext context) {
    final isSelected = code == selected;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF3F6FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFFF8B324) : const Color(0xFFE6EEF7)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFF8B324)),
          ],
        ),
      ),
    );
  }
}
