import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final ValueChanged<Map<String, dynamic>> onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const _amenities = ['wifi', 'parking', 'coffee', 'meeting_room'];
  static const _crowd = ['low', 'medium', 'high'];
  static const _payments = ['cash', 'card', 'wallet', 'bank_transfer'];

  late RangeValues _priceRange;
  late Set<String> _selectedDays;
  late Set<String> _selectedAmenities;
  late Set<String> _selectedCrowd;
  late Set<String> _selectedPayments;

  @override
  void initState() {
    super.initState();
    final min = (widget.initialFilters['priceMin'] as num?)?.toDouble() ?? 0;
    final max = (widget.initialFilters['priceMax'] as num?)?.toDouble() ?? 200;
    _priceRange = RangeValues(min.clamp(0, 200), max.clamp(0, 200));

    _selectedDays =
        ((widget.initialFilters['days'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
    _selectedAmenities =
        ((widget.initialFilters['amenities'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
    _selectedCrowd =
        ((widget.initialFilters['crowdLevels'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
    _selectedPayments =
        ((widget.initialFilters['paymentMethods'] as List?) ?? const [])
            .map((e) => e.toString())
            .toSet();
  }

  Map<String, dynamic> _buildFilters() {
    return {
      'priceMin': _priceRange.start.roundToDouble(),
      'priceMax': _priceRange.end.roundToDouble(),
      'days': _selectedDays.toList(growable: false),
      'amenities': _selectedAmenities.toList(growable: false),
      'crowdLevels': _selectedCrowd.toList(growable: false),
      'paymentMethods': _selectedPayments.toList(growable: false),
    };
  }

  Widget _chips({
    required List<String> options,
    required Set<String> selected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map(
            (item) => FilterChip(
              selected: selected.contains(item),
              label: Text(item),
              onSelected: (_) {
                setState(() {
                  if (selected.contains(item)) {
                    selected.remove(item);
                  } else {
                    selected.add(item);
                  }
                });
              },
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text('Price: ${_priceRange.start.round()} - ${_priceRange.end.round()}'),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                activeColor: AppColors.btnPrimary,
                onChanged: (value) => setState(() => _priceRange = value),
              ),
              const SizedBox(height: 12),
              const Text('Days', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _chips(options: _days, selected: _selectedDays),
              const SizedBox(height: 12),
              const Text('Amenities', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _chips(options: _amenities, selected: _selectedAmenities),
              const SizedBox(height: 12),
              const Text('Crowd level', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _chips(options: _crowd, selected: _selectedCrowd),
              const SizedBox(height: 12),
              const Text('Payment methods', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _chips(options: _payments, selected: _selectedPayments),
              const SizedBox(height: 16),
              AppButton(
                label: 'Apply',
                onPressed: () {
                  widget.onApply(_buildFilters());
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  widget.onReset();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
