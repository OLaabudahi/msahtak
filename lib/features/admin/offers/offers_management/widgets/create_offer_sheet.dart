import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../_shared/admin_ui.dart';
import '../bloc/offers_management_event.dart';
import '../bloc/offers_management_state.dart';
import '../domain/entities/offer_duration_unit.dart';
import '../domain/entities/offer_type.dart';
import '../../../my_spaces/add_edit_space/domain/entities/price_unit.dart';

class CreateOfferSheet extends StatelessWidget {
  final OffersCreateForm form;
  final void Function(OffersManagementEvent event) dispatch;

  const CreateOfferSheet({
    super.key,
    required this.form,
    required this.dispatch,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AdminColors.black10,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(child: Text('Create Offer', style: AdminText.h2())),
                  InkWell(
                    onTap: () => dispatch(const OffersManagementCreateClosed()),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        AdminIconMapper.xCircle(),
                        size: 20,
                        color: AdminColors.black40,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _Field(
                label: 'Title',
                hint: 'Offer title',
                value: form.title,
                error: form.titleError,
                onChanged: (v) =>
                    dispatch(OffersManagementCreateFieldChanged('title', v)),
              ),
              const SizedBox(height: 10),

              _Field(
                label: 'Valid until',
                hint: 'e.g. Sep 30',
                value: form.validUntil,
                error: form.validUntilError,
                onChanged: (v) => dispatch(
                  OffersManagementCreateFieldChanged('validUntil', v),
                ),
              ),

              const SizedBox(height: 10),

              _Row(
                label: 'Type',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OfferType>(
                    value: form.type,
                    items: const [
                      DropdownMenuItem(
                        value: OfferType.fixedPriceOverride,
                        child: Text('Fixed Price'),
                      ),
                      DropdownMenuItem(
                        value: OfferType.discountPercent,
                        child: Text('Discount %'),
                      ),
                      DropdownMenuItem(
                        value: OfferType.packageMonths,
                        child: Text('Package (Months)'),
                      ),
                      DropdownMenuItem(
                        value: OfferType.bonus,
                        child: Text('Bonus'),
                      ),
                    ],
                    onChanged: (v) => v == null
                        ? null
                        : dispatch(OffersManagementCreateTypeChanged(v)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: 'Duration (optional)',
                      hint: 'e.g. 7',
                      value: form.durationValue,
                      error: form.durationError,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (v) => dispatch(
                        OffersManagementCreateFieldChanged('durationValue', v),
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
                      child: DropdownButton<OfferDurationUnit>(
                        value: form.durationUnit,
                        items: const [
                          DropdownMenuItem(
                            value: OfferDurationUnit.days,
                            child: Text('days'),
                          ),
                          DropdownMenuItem(
                            value: OfferDurationUnit.weeks,
                            child: Text('weeks'),
                          ),
                          DropdownMenuItem(
                            value: OfferDurationUnit.months,
                            child: Text('months'),
                          ),
                        ],
                        onChanged: (v) => v == null
                            ? null
                            : dispatch(
                                OffersManagementCreateDurationUnitChanged(v),
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              
              if (form.type == OfferType.discountPercent) ...[
                _Field(
                  label: 'Discount %',
                  hint: '1..100',
                  value: form.discountPercent,
                  error: form.discountError,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*([.,]\d{0,2})?$'),
                    ),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (v) => dispatch(
                    OffersManagementCreateFieldChanged('discountPercent', v),
                  ),
                ),
              ] else if (form.type == OfferType.fixedPriceOverride) ...[
                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        label: 'Fixed price',
                        hint: 'e.g. 25',
                        value: form.fixedPriceValue,
                        error: form.fixedPriceError,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*([.,]\d{0,2})?$'),
                          ),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (v) => dispatch(
                          OffersManagementCreateFieldChanged(
                            'fixedPriceValue',
                            v,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AdminColors.black15,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PriceUnit>(
                          value: form.fixedPriceUnit,
                          items: const [
                            DropdownMenuItem(
                              value: PriceUnit.day,
                              child: Text('day'),
                            ),
                            DropdownMenuItem(
                              value: PriceUnit.week,
                              child: Text('week'),
                            ),
                            DropdownMenuItem(
                              value: PriceUnit.month,
                              child: Text('month'),
                            ),
                          ],
                          onChanged: (v) => v == null
                              ? null
                              : dispatch(
                                  OffersManagementCreateFixedUnitChanged(v),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (form.type == OfferType.packageMonths) ...[
                _Row(
                  label: 'Package months',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: form.packageMonths,
                      items: const [
                        DropdownMenuItem(value: 3, child: Text('3 months')),
                        DropdownMenuItem(value: 6, child: Text('6 months')),
                        DropdownMenuItem(value: 9, child: Text('9 months')),
                        DropdownMenuItem(value: 12, child: Text('12 months')),
                      ],
                      onChanged: (v) => v == null
                          ? null
                          : dispatch(
                              OffersManagementCreatePackageMonthsChanged(v),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _Field(
                  label: 'Discount % (optional)',
                  hint: 'e.g. 10',
                  value: form.packageDiscountPercent,
                  error: form.packageError,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*([.,]\d{0,2})?$'),
                    ),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (v) => dispatch(
                    OffersManagementCreateFieldChanged(
                      'packageDiscountPercent',
                      v,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _Field(
                  label: 'Fixed monthly price (optional)',
                  hint: 'e.g. 250',
                  value: form.fixedMonthlyPrice,
                  error: form.packageError,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*([.,]\d{0,2})?$'),
                    ),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (v) => dispatch(
                    OffersManagementCreateFieldChanged('fixedMonthlyPrice', v),
                  ),
                ),
                if (form.packageError != null) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      form.packageError!,
                      style: AdminText.label12(
                        color: AdminColors.danger,
                        w: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ] else if (form.type == OfferType.bonus) ...[
                _Field(
                  label: 'Bonus text',
                  hint: 'e.g. +1 hour free',
                  value: form.bonusText,
                  error: form.bonusError,
                  onChanged: (v) => dispatch(
                    OffersManagementCreateFieldChanged('bonusText', v),
                  ),
                  maxLines: 2,
                ),
              ],

              const SizedBox(height: 14),

              AdminButton.filled(
                label: 'Create',
                onTap: () => dispatch(const OffersManagementCreateSubmitted()),
                bg: AdminColors.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final Widget child;

  const _Row({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AdminText.body14(
                color: AdminColors.black75,
                w: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final String? error;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const _Field({
    required this.label,
    required this.hint,
    required this.value,
    required this.error,
    required this.onChanged,
    this.maxLines = 1,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AdminText.body14(
              color: AdminColors.black75,
              w: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: AdminText.body16(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AdminText.body16(color: AdminColors.black40),
              errorText: error,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AdminColors.black15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AdminColors.black15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AdminColors.black15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
