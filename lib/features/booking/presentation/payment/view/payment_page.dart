import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../booking_feature_routes.dart';
import 'payment_success_page.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/payment_booking_summary_card.dart';
import '../widgets/payment_method_tile.dart';

class PaymentPage extends StatelessWidget {
  final String requestId;

  const PaymentPage({super.key, required this.requestId});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PaymentBloc, PaymentState>(
          listenWhen: (p, c) => p.uiStatus != c.uiStatus,
          listener: (context, state) {
            if (state.uiStatus == PaymentUiStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.uiStatus == PaymentUiStatus.success && state.receipt != null) {
              Navigator.of(context).pushReplacement(
                BookingFeatureRoutes.paymentSuccess(
                  args: PaymentSuccessArgs(
                    bookingId: state.receipt!.bookingId,
                    amountPaid: state.receipt!.amountPaid,
                    currency: state.receipt!.currency,
                    paidAt: state.receipt!.paidAt,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isBusy = state.uiStatus == PaymentUiStatus.loading || state.uiStatus == PaymentUiStatus.paying;

            return AbsorbPointer(
              absorbing: isBusy,
              child: ListView(
                padding: _pagePadding,
                children: [
                  if (isBusy) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 10),

                  PaymentBookingSummaryCard(summary: state.summary),
                  const SizedBox(height: 14),

                  const Text('Payment method', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),

                  ...state.methods.map(
                        (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PaymentMethodTile(
                        title: m.title,
                        selected: state.selectedMethod == m.type,
                        onTap: () => context.read<PaymentBloc>().add(PaymentMethodSelected(m.type)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.canPay ? () => context.read<PaymentBloc>().add(PayNowPressed(requestId)) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      child: state.uiStatus == PaymentUiStatus.paying
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Pay now', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

