import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

class BookingStartDateField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const BookingStartDateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DropdownTile(
      hint: 'Select Date',
      value: value == null ? null : _fmtDate(value!),
      onTap: () async {
        final now = DateTime.now();
        final initial = value ?? DateTime(now.year, now.month, now.day);

        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(now.year, now.month, now.day),
          lastDate: DateTime(now.year + 2),
          initialDate: initial,
        );

        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }

  static String _fmtDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
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



