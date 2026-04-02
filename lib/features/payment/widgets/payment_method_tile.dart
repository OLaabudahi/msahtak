import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.amber : AppColors.inputBorder),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.amber),
          ],
        ),
      ),
    );
  }
}



