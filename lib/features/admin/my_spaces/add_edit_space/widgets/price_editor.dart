import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/price_unit.dart';

class PriceEditor extends StatelessWidget {
  final String valueText;
  final PriceUnit unit;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<PriceUnit> onUnitChanged;
  final String? errorText;

  const PriceEditor({
    super.key,
    required this.valueText,
    required this.unit,
    required this.onValueChanged,
    required this.onUnitChanged,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Base Price', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*([.,]\d{0,2})?$')),
                  ],
                  onChanged: onValueChanged,
                  controller: TextEditingController(text: valueText)
                    ..selection = TextSelection.collapsed(offset: valueText.length),
                  style: AdminText.body16(),
                  decoration: InputDecoration(
                    hintText: 'e.g. 35',
                    hintStyle: AdminText.body16(color: AdminColors.black40),
                    errorText: errorText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AdminColors.black15, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PriceUnit>(
                    value: unit,
                    items: [
                      DropdownMenuItem(value: PriceUnit.day, child: Text(context.t('day'))),
                      DropdownMenuItem(value: PriceUnit.week, child: Text(context.t('week'))),
                      DropdownMenuItem(value: PriceUnit.month, child: Text(context.t('month'))),
                    ],
                    onChanged: (v) {
                      if (v != null) onUnitChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


