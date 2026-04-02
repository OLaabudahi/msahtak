import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

class BookingOfferDropdown extends StatelessWidget {
  final String? selectedLabel;
  final ValueChanged<BookingOfferPick?> onChanged;

  const BookingOfferDropdown({
    super.key,
    required this.selectedLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DropdownTile(
      hint: 'Choose an offer or skip',
      value: selectedLabel,
      onTap: () async {
        final picked = await _pickFromBottomSheet(
          context,
          title: 'Offer',
          items: const [
            BookingOfferPick(id: null, label: 'Skip'),
            BookingOfferPick(id: 'WEEKLY', label: 'Weekly plan'),
            BookingOfferPick(id: 'MONTHLY', label: 'Monthly plan'),
            BookingOfferPick(id: 'PROMO', label: 'Promo'),
          ],
        );
        onChanged(picked);
      },
    );
  }
}

class BookingOfferPick {
  final String? id;
  final String label;

  const BookingOfferPick({required this.id, required this.label});
}

Future<BookingOfferPick?> _pickFromBottomSheet(
    BuildContext context, {
      required String title,
      required List<BookingOfferPick> items,
    }) {
  return showModalBottomSheet<BookingOfferPick>(
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

