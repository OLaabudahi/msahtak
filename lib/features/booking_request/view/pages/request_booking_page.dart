import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/booking_request_bloc.dart';
import '../../bloc/booking_request_event.dart';
import '../../bloc/booking_request_state.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../widgets/booking_addon_switch_tile.dart';
import '../../widgets/booking_duration_selector.dart';
import '../../widgets/booking_price_summary_card.dart';
import '../../widgets/booking_request_header_card.dart';
import '../booking_request_routes.dart';

class RequestBookingPage extends StatelessWidget {
  final SpaceSummaryEntity space;

  const RequestBookingPage({super.key, required this.space});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<BookingRequestBloc, BookingRequestState>(
          listenWhen: (p, c) => p.uiStatus != c.uiStatus,
          listener: (context, state) {
            if (state.uiStatus == BookingRequestUiStatus.success && state.createdRequest != null) {
              Navigator.of(context).pushReplacement(
                BookingRequestRoutes.pendingApproval(
                  request: state.createdRequest!,
                ),
              );}


            if (state.uiStatus == BookingRequestUiStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            final isBusy = state.uiStatus == BookingRequestUiStatus.loading ||
                state.uiStatus == BookingRequestUiStatus.quoting ||
                state.uiStatus == BookingRequestUiStatus.submitting;

            return AbsorbPointer(
              absorbing: isBusy,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: _pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingRequestHeaderCard(space: space),
                    const SizedBox(height: 14),

                    _Label('Purpose'),
                    _DropdownTile(
                      hint: 'Select purpose',
                      value: state.purposeLabel,
                      onTap: () async {
                        final picked = await _pickFromBottomSheet(
                          context,
                          title: 'Select purpose',
                          items: const [
                            _PickItem(id: 'WORK', label: 'Work'),
                            _PickItem(id: 'MEETING', label: 'Meeting'),
                            _PickItem(id: 'STUDY', label: 'Study'),
                          ],
                        );
                        if (picked != null && context.mounted) {
                          context.read<BookingRequestBloc>().add(
                            PurposeChanged(purposeId: picked.id, purposeLabel: picked.label),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    _Label('Start Date'),
                    _DropdownTile(
                      hint: 'Select Date',
                      value: state.startDate == null ? null : _fmtDate(state.startDate!),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(now.year, now.month, now.day),
                          lastDate: DateTime(now.year + 2),
                          initialDate: state.startDate ?? now,
                        );
                        if (picked != null && context.mounted) {
                          context.read<BookingRequestBloc>().add(StartDateChanged(picked));
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    _Label('Duration'),
                    BookingDurationSelector(
                      unit: state.durationUnit,
                      value: state.durationValue,
                      onUnitChanged: (u) => context.read<BookingRequestBloc>().add(DurationUnitChanged(u)),
                      onValueChanged: (v) => context.read<BookingRequestBloc>().add(DurationValueChanged(v)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${state.durationValue} ${state.durationUnit.name}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textDark),
                    ),
                    const SizedBox(height: 10),

                    // Banner (Weekly plan cheaper)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Weekly plan is cheaper for you',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Dummy: switch offer to WEEKLY
                              context.read<BookingRequestBloc>().add(
                                const OfferChanged(offerId: 'WEEKLY', offerLabel: 'Weekly plan'),
                              );
                            },
                            child: const Text('Switch'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _Label('Offer (optional)'),
                    _DropdownTile(
                      hint: 'Choose an offer or skip',
                      value: state.offerLabel,
                      onTap: () async {
                        final picked = await _pickFromBottomSheet(
                          context,
                          title: 'Offer',
                          items: const [
                            _PickItem(id: null, label: 'Skip'),
                            _PickItem(id: 'WEEKLY', label: 'Weekly plan'),
                            _PickItem(id: 'MONTHLY', label: 'Monthly plan'),
                            _PickItem(id: 'PROMO', label: 'Promo'),
                          ],
                        );
                        if (picked != null && context.mounted) {
                          context.read<BookingRequestBloc>().add(
                            OfferChanged(offerId: picked.id, offerLabel: picked.label == 'Skip' ? null : picked.label),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    _Label('Add-ons (optional)'),
                    ...state.addOns.map(
                          (a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BookingAddOnSwitchTile(
                          title: a.title,
                          subtitle: '${a.currencySymbol}${a.price} ${a.unitLabel}',
                          value: a.isSelected,
                          onChanged: (v) => context.read<BookingRequestBloc>().add(AddOnToggled(addOnId: a.id, isSelected: v)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Label('Price summary'),
                    BookingPriceSummaryCard(
                      quote: state.quote,
                      durationValue: state.durationValue,
                      currency: space.currency,
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.canSubmit
                            ? () => context.read<BookingRequestBloc>().add(const SubmitBookingRequestPressed())
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amber,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: state.uiStatus == BookingRequestUiStatus.submitting
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Text(
                          'Send Request Booking',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

extension on AddOnEntity {
  String get currencySymbol => '₪';
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
    );
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

class _PickItem {
  final String? id;
  final String label;
  const _PickItem({required this.id, required this.label});
}

Future<_PickItem?> _pickFromBottomSheet(
    BuildContext context, {
      required String title,
      required List<_PickItem> items,
    }) {
  return showModalBottomSheet<_PickItem>(
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

