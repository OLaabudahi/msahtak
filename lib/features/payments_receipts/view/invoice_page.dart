import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/app_injector.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/invoice/invoice_event.dart';
import '../bloc/invoice/invoice_state.dart';
import '../domain/entities/user_receipt_entity.dart';

class InvoicePage extends StatelessWidget {
  final UserReceiptEntity invoice;

  const InvoicePage({
    super.key,
    required this.invoice,
  });

  static Widget withBloc(UserReceiptEntity invoice) {
    return BlocProvider(
      create: (_) => getIt<InvoiceBloc>(),
      child: InvoicePage(invoice: invoice),
    );
  }

  String _fmtDateTime(DateTime value) {
    return DateFormat('dd/MM/yyyy HH:mm').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error || prev.successKey != curr.successKey,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.successKey != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t(state.successKey!))),
          );
        }
      },builder: (BuildContext context, InvoiceState state) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(context.t('invoice')),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long, size: 42, color: AppColors.amber),
                      const SizedBox(height: 8),
                      Text(
                        context.t('invoice').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        invoice.spaceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.t('generatedAt')}: ${_fmtDateTime(invoice.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.t('bookingInformation'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Divider(),
                _kv(context, context.t('bookingId'), invoice.bookingId),
                _kv(context, context.t('spaceName'), invoice.spaceName),
                _kv(context, context.t('customerName'), invoice.userName.isEmpty ? '-' : invoice.userName),
                _kv(context, context.t('email'), invoice.userEmail.isEmpty ? '-' : invoice.userEmail),
                _kv(context, context.t('startDate'), _fmtDateTime(invoice.startDate)),
                _kv(context, context.t('endDate'), _fmtDateTime(invoice.endDate)),
                const SizedBox(height: 18),
                Text(
                  context.t('paymentInformation'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Divider(),
                _kv(
                  context,
                  context.t('amountPaid'),
                  '${invoice.totalPrice.toStringAsFixed(2)} ${invoice.currency}',
                ),
                _kv(context, context.t('paymentMethod'), invoice.paymentMethod),
                _kv(context, context.t('date'), _fmtDateTime(invoice.createdAt)),
                _kv(context, context.t('status'), invoice.status),
                const SizedBox(height: 18),
                Text(
                  context.t('invoiceFooterNote'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.loading
                                ? null
                                : () {
                                    context.read<InvoiceBloc>().add(
                                          InvoiceDownloadRequested(invoice),
                                        );
                                  },
                            icon: const Icon(Icons.download_outlined),
                            label: Text(context.t('downloadInvoice')),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: state.loading
                                ? null
                                : () {
                                    context.read<InvoiceBloc>().add(
                                          InvoiceShareRequested(invoice),
                                        );
                                  },
                            icon: const Icon(Icons.share_outlined),
                            label: Text(context.t('shareInvoice')),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kv(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              key,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
