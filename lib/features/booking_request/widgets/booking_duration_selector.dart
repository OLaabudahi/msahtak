import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../domain/entities/booking_request_entity.dart';


class BookingDurationSelector extends StatelessWidget {
  final DurationUnit unit;
  final int value;
  final ValueChanged<DurationUnit> onUnitChanged;
  final ValueChanged<int> onValueChanged;

  const BookingDurationSelector({
    super.key,
    required this.unit,
    required this.value,
    required this.onUnitChanged,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _UnitDropdown(
            unit: unit,
            onChanged: onUnitChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.inputBorder),
              color: Colors.white,
            ),
            child: Row(
              children: [
                _CircleButton(
                  icon: Icons.remove,
                  onTap: () => onValueChanged((value - 1).clamp(1, 365)),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$value',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ),
                _CircleButton(
                  icon: Icons.add,
                  onTap: () => onValueChanged((value + 1).clamp(1, 365)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final DurationUnit unit;
  final ValueChanged<DurationUnit> onChanged;

  const _UnitDropdown({required this.unit, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DurationUnit>(
          value: unit,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: DurationUnit.days, child: Text('Days')),
            DropdownMenuItem(value: DurationUnit.weeks, child: Text('Weeks')),
            DropdownMenuItem(value: DurationUnit.months, child: Text('Months')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.amber,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

