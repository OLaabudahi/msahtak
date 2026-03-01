import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/payments_bloc.dart';
import '../bloc/payments_event.dart';
import '../bloc/payments_state.dart';
import '../data/repos/payments_repo_impl.dart';
import '../data/sources/payments_dummy_source.dart';
import '../domain/entities/payment_status.dart';
import '../domain/usecases/get_payment_details_usecase.dart';
import '../domain/usecases/get_payments_usecase.dart';
import '../domain/usecases/issue_refund_usecase.dart';

class PaymentsRefundsPage extends StatelessWidget {
  final bool fromHome;
  const PaymentsRefundsPage({super.key, required this.fromHome});

  static Widget withBloc({bool fromHome = false}) {
    final source = PaymentsDummySource();
    final repo = PaymentsRepoImpl(source);
    return BlocProvider(
      create: (_) => PaymentsBloc(
        getPayments: GetPaymentsUseCase(repo),
        getDetails: GetPaymentDetailsUseCase(repo),
        refund: IssueRefundUseCase(repo),
      )..add(const PaymentsStarted()),
      child: PaymentsRefundsPage(fromHome: fromHome),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<PaymentsBloc, PaymentsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: 'Payments & Refunds',
                        subtitle: 'Filter and manage transactions',
                        onBack: fromHome ? () => Navigator.of(context).maybePop() : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(child: _Drop(label: _periodLabel(state.periodId), onTap: () async {
                              final picked = await _pickPeriod(context);
                              if (picked != null) context.read<PaymentsBloc>().add(PaymentsPeriodChanged(picked));
                            })),
                            const SizedBox(width: 8),
                            Expanded(child: _Drop(label: _statusLabel(state.filter), onTap: () async {
                              final picked = await _pickStatus(context);
                              if (picked != null) context.read<PaymentsBloc>().add(PaymentsStatusChanged(picked));
                            })),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: state.payments.map((p) {
                            final tag = switch (p.status) {
                              PaymentStatus.pending => AdminTag(text: 'Pending', tint: AdminColors.primaryAmber.withOpacity(0.15), textColor: AdminColors.primaryAmber),
                              PaymentStatus.refunded => AdminTag(text: 'Refunded', tint: AdminColors.danger.withOpacity(0.15), textColor: AdminColors.danger),
                              _ => AdminTag(text: 'Paid', tint: AdminColors.success.withOpacity(0.15), textColor: AdminColors.success),
                            };

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () async {
                                  context.read<PaymentsBloc>().add(PaymentsOpenDetails(p.id));
                                  await showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: AdminColors.bg,
                                    barrierColor: const Color(0x66000000),
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: AdminRadii.r24)),
                                    builder: (_) => _PaymentDetailsSheet(paymentId: p.id),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: AdminCard(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(p.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                                            const SizedBox(height: 4),
                                            Text('${p.date} • Booking ${p.bookingId}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40)),
                                            const SizedBox(height: 8),
                                            tag,
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(p.amount, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(growable: false),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static String _periodLabel(String id) => switch (id) { 'last7' => 'Last 7 days', 'last90' => 'Last 90 days', _ => 'Last 30 days' };
  static String _statusLabel(PaymentStatus s) => switch (s) { PaymentStatus.pending => 'Pending', PaymentStatus.refunded => 'Refunded', _ => 'Paid' };

  static Future<String?> _pickPeriod(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Select Period', style: AdminText.body16(w: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Opt(label: 'Last 7 days', onTap: () => Navigator.of(context).pop('last7')),
            _Opt(label: 'Last 30 days', onTap: () => Navigator.of(context).pop('last30')),
            _Opt(label: 'Last 90 days', onTap: () => Navigator.of(context).pop('last90')),
          ],
        ),
      ),
    );
  }

  static Future<PaymentStatus?> _pickStatus(BuildContext context) async {
    return showDialog<PaymentStatus>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (_) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Select Status', style: AdminText.body16(w: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Opt(label: 'Paid', onTap: () => Navigator.of(context).pop(PaymentStatus.paid)),
            _Opt(label: 'Pending', onTap: () => Navigator.of(context).pop(PaymentStatus.pending)),
            _Opt(label: 'Refunded', onTap: () => Navigator.of(context).pop(PaymentStatus.refunded)),
          ],
        ),
      ),
    );
  }
}

class _Drop extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Drop({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.black15, width: 1),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w500))),
            Icon(AdminIconMapper.chevronDown(), size: 18, color: AdminColors.black40),
          ],
        ),
      ),
    );
  }
}

class _Opt extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Opt({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

class _PaymentDetailsSheet extends StatelessWidget {
  final String paymentId;
  const _PaymentDetailsSheet({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: BlocBuilder<PaymentsBloc, PaymentsState>(
            builder: (context, state) {
              final d = state.details;
              if (state.status == PaymentsStatusView.acting && d == null) {
                return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Details', style: AdminText.h2()),
                  const SizedBox(height: 16),
                  AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d?.userName ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text('Booking: ${d?.bookingId ?? '-'}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                        const SizedBox(height: 12),
                        _kv('Amount', d?.amount ?? '-'),
                        _kv('Status', d?.status ?? '-'),
                        _kv('Method', d?.method ?? '-'),
                        _kv('Reference', d?.reference ?? '-'),
                        _kv('Date', d?.date ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AdminButton.filled(
                    label: 'Issue Refund',
                    onTap: () {
                      context.read<PaymentsBloc>().add(PaymentsIssueRefund(paymentId));
                      Navigator.of(context).pop();
                    },
                    bg: AdminColors.danger,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(k, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40))),
          const SizedBox(width: 12),
          Expanded(child: Text(v, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600))),
        ],
      ),
    );
  }
}
