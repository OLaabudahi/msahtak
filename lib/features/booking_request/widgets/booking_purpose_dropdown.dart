import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

class BookingPurposeDropdown extends StatelessWidget {
  final String? selectedLabel;
  final ValueChanged<BookingPickItem?> onChanged;

  const BookingPurposeDropdown({
    super.key,
    required this.selectedLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DropdownTile(
      hint: 'Select purpose',
      value: selectedLabel,
      onTap: () async {
        final picked = await _pickFromBottomSheet(
          context,
          title: 'Select purpose',
          items: const [
            BookingPickItem(id: 'WORK', label: 'Work'),
            BookingPickItem(id: 'MEETING', label: 'Meeting'),
            BookingPickItem(id: 'STUDY', label: 'Study'),
            BookingPickItem(id: 'EVENT', label: 'Event'),
          ],
        );
        onChanged(picked);
      },
    );
  }
}

class BookingPickItem {
  final String? id;
  final String label;

  const BookingPickItem({required this.id, required this.label});
}

Future<BookingPickItem?> _pickFromBottomSheet(
    BuildContext context, {
      required String title,
      required List<BookingPickItem> items,
    }) {
  return showModalBottomSheet<BookingPickItem>(
    context: context,
    showDragHandle: true,
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            const Divider(height: 1),
            ...items.map(
                  (i) => ListTile(
                title: Text(i.label),
                onTap: () => Navigator.of(context).pop(i),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

class _DropdownTile extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const _DropdownTile({
    required this.hint,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: value == null ? AppColors.textSecondary : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}

