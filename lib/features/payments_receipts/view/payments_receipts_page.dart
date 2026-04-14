import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../bloc/payments_receipts_bloc.dart';
import '../bloc/payments_receipts_event.dart';
import '../bloc/payments_receipts_state.dart';
import '../domain/entities/user_receipt_entity.dart';
import 'invoice_page.dart';

class PaymentsReceiptsPage extends StatelessWidget {
  const PaymentsReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('paymentsReceipts'),
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<PaymentsReceiptsBloc, PaymentsReceiptsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          final visibleReceipts = state.showAllReceipts
              ? state.receipts
              : state.receipts.take(2).toList(growable: false);
          final recentPayments = state.receipts.take(2).toList(growable: false);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _MonthlySpendingCard(
                  monthlyPayments: state.monthlyPayments,
                  currency: state.receipts.isEmpty ? '' : state.receipts.first.currency,
                ),
                const SizedBox(height: 14),
                _RecentPaymentsCard(recentPayments: recentPayments),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.t('receipts'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: state.receipts.length <= 2
                          ? null
                          : () => context.read<PaymentsReceiptsBloc>().add(
                                const PaymentsReceiptsToggleViewMoreRequested(),
                              ),
                      child: Text(context.t('viewMore')),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (visibleReceipts.isEmpty)
                  const _EmptyState()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleReceipts.length,
                    itemBuilder: (context, index) {
                      final receipt = visibleReceipts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReceiptCard(
                          receipt: receipt,
                          onOpenInvoice: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => InvoicePage.withBloc(receipt),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthlySpendingCard extends StatelessWidget {
  final Map<int, double> monthlyPayments;
  final String currency;

  const _MonthlySpendingCard({
    required this.monthlyPayments,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final total = monthlyPayments.values.fold<double>(0, (p, e) => p + e);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('monthlySpending'),
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${context.t('monthlySpending')}: ${total.toStringAsFixed(2)} $currency',
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsCard extends StatelessWidget {
  final List<UserReceiptEntity> recentPayments;

  const _RecentPaymentsCard({required this.recentPayments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('recentPayments'),
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (recentPayments.isEmpty)
            const Text('-', style: TextStyle(color: AppColors.textSecondary))
          else
            ...recentPayments.map(
              (payment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        payment.spaceName,
                        style: const TextStyle(color: AppColors.text),
                      ),
                    ),
                    Text(
                      '${payment.totalPrice.toStringAsFixed(2)} ${payment.currency}',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final UserReceiptEntity receipt;
  final VoidCallback onOpenInvoice;

  const _ReceiptCard({
    required this.receipt,
    required this.onOpenInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('dd/MM/yyyy').format(receipt.startDate);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receipt.spaceName,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${context.t('date')}: $dateText',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            '${receipt.totalPrice.toStringAsFixed(2)} ${receipt.currency}',
            style: const TextStyle(color: AppColors.text),
          ),
          Text(
            '${context.t('status')}: ${receipt.status}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onOpenInvoice,
            icon: const Icon(Icons.receipt_long_outlined),
            label: Text(context.t('invoice')),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        context.t('noReceiptAvailable'),
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
