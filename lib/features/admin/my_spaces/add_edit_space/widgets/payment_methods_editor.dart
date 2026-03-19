import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../../../../../core/i18n/app_i18n.dart';

/// الطرق المتاحة للإضافة مع نوعها
const _kAvailableMethods = [
  {'id': 'credit_card',       'name': 'Credit / Debit Card', 'type': 'card'},
  {'id': 'pal_pay',           'name': 'PalPay',              'type': 'wallet'},
  {'id': 'jawwal_pay',        'name': 'Jawwal Pay',          'type': 'wallet'},
  {'id': 'bank_of_palestine', 'name': 'Bank of Palestine',   'type': 'bank'},
];

String _methodType(String id) =>
    _kAvailableMethods.firstWhere((m) => m['id'] == id, orElse: () => {'type': 'bank'})['type']!;

String _methodDisplayName(String id) =>
    _kAvailableMethods.firstWhere((m) => m['id'] == id, orElse: () => {'name': id})['name']!;

/// محرر طرق الدفع — Dropdown + Add + حقول مخصصة لكل طريقة
class PaymentMethodsEditor extends StatefulWidget {
  final List<Map<String, String>> selectedMethods;
  final void Function(String id, String name) onAdd;
  final void Function(String id) onRemove;
  final void Function(String id, String fieldKey, String value) onFieldChanged;

  const PaymentMethodsEditor({
    super.key,
    required this.selectedMethods,
    required this.onAdd,
    required this.onRemove,
    required this.onFieldChanged,
  });

  @override
  State<PaymentMethodsEditor> createState() => _PaymentMethodsEditorState();
}

class _PaymentMethodsEditorState extends State<PaymentMethodsEditor> {
  String? _dropdownValue;

  List<Map<String, String>> get _available => _kAvailableMethods
      .where((m) => !widget.selectedMethods.any((s) => s['id'] == m['id']))
      .toList();

  @override
  Widget build(BuildContext context) {
    final available = _available;

    // إذا الـ dropdown value لا يوجد في القائمة المتاحة → reset بعد الـ frame
    final effectiveDropdown = (available.any((m) => m['id'] == _dropdownValue)) ? _dropdownValue : null;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(children: [
            const Icon(Icons.payment_outlined, size: 18, color: AdminColors.black75),
            const SizedBox(width: 8),
            Text(context.t('adminPaymentMethodsTitle'),
                style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Text(context.t('adminPaymentMethodsSubtitle'),
              style: AdminText.label12(color: AdminColors.black40)),
          const SizedBox(height: 14),

          // ── Dropdown + Add ──
          if (available.isNotEmpty)
            Row(children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.black15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: effectiveDropdown,
                      hint: Text(context.t('adminSelectPaymentMethod'),
                          style: AdminText.body14(color: AdminColors.black40)),
                      isExpanded: true,
                      style: AdminText.body14(color: AdminColors.text),
                      items: available.map((m) => DropdownMenuItem<String>(
                            value: m['id'],
                            child: Text(m['name']!),
                          )).toList(),
                      onChanged: (v) => setState(() => _dropdownValue = v),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                width: 90,
                child: ElevatedButton(
                  onPressed: effectiveDropdown == null
                      ? null
                      : () {
                          final id = effectiveDropdown;
                          final name = _methodDisplayName(id);
                          widget.onAdd(id, name);
                          setState(() => _dropdownValue = null);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.primaryBlue,
                    disabledBackgroundColor: AdminColors.black15,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(context.t('adminAddPaymentMethod'),
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ]),

          if (available.isNotEmpty && widget.selectedMethods.isNotEmpty)
            const SizedBox(height: 14),

          // ── Added Methods ──
          ...widget.selectedMethods.map((m) {
            final id = m['id']!;
            final type = _methodType(id);
            return _MethodCard(
              key: ValueKey(id),
              method: m,
              type: type,
              onRemove: () => widget.onRemove(id),
              onFieldChanged: (key, val) => widget.onFieldChanged(id, key, val),
            );
          }),
        ],
      ),
    );
  }
}

/// كارد طريقة دفع واحدة مضافة مع حقولها المخصصة
class _MethodCard extends StatelessWidget {
  final Map<String, String> method;
  final String type;
  final VoidCallback onRemove;
  final void Function(String key, String value) onFieldChanged;

  const _MethodCard({
    super.key,
    required this.method,
    required this.type,
    required this.onRemove,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.primaryBlue.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── اسم الطريقة + زر حذف ──
          Row(children: [
            Icon(_icon(), size: 18, color: AdminColors.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(method['name'] ?? method['id']!,
                  style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, size: 18, color: AdminColors.danger),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),

          const SizedBox(height: 12),

          // ── الحقول حسب نوع الطريقة ──
          if (type == 'bank') ..._bankFields(context),
          if (type == 'wallet') ..._walletFields(context),
          if (type == 'card') ..._cardFields(context),
        ],
      ),
    );
  }

  IconData _icon() {
    return switch (type) {
      'card' => Icons.credit_card,
      'wallet' => Icons.phone_android,
      _ => Icons.account_balance,
    };
  }

  List<Widget> _bankFields(BuildContext context) => [
        _Field(
          label: 'IBAN',
          initialValue: method['iban'] ?? '',
          hint: 'PS00XXXX...',
          onChanged: (v) => onFieldChanged('iban', v),
        ),
        const SizedBox(height: 10),
        _Field(
          label: context.t('adminPaymentAccountName'),
          initialValue: method['accountName'] ?? '',
          hint: context.t('adminPaymentAccountNameHint'),
          onChanged: (v) => onFieldChanged('accountName', v),
        ),
      ];

  List<Widget> _walletFields(BuildContext context) => [
        _Field(
          label: context.t('adminPaymentPhone'),
          initialValue: method['phone'] ?? '',
          hint: '059-XXXXXXX',
          keyboardType: TextInputType.phone,
          onChanged: (v) => onFieldChanged('phone', v),
        ),
      ];

  List<Widget> _cardFields(BuildContext context) => [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdminColors.black15),
          ),
          child: Text(
            context.t('adminPaymentCardNote'),
            style: AdminText.label12(color: AdminColors.black40),
          ),
        ),
      ];
}

class _Field extends StatefulWidget {
  final String label;
  final String initialValue;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _Field({
    super.key,
    required this.label,
    required this.initialValue,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AdminText.label12(color: AdminColors.black75)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _ctrl,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: AdminText.body14(color: AdminColors.text),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AdminText.body14(color: AdminColors.black40),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AdminColors.black15)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AdminColors.black15)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AdminColors.primaryBlue)),
          ),
        ),
      ],
    );
  }
}
