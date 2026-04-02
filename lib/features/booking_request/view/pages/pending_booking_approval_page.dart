import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../core/i18n/app_i18n.dart';
import '../../bloc/booking_request_bloc.dart';
import '../../domain/entities/booking_request_entity.dart';
import '../../widgets/booking_request_summary_card.dart';
import '../booking_request_routes.dart';


class PendingBookingApprovalPage extends StatelessWidget {
  final BookingRequestEntity request;

  const PendingBookingApprovalPage({super.key, required this.request});

  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    final canViewStatus = request.bookingId.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('pendingApprovalTitle')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: _pagePadding,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _SuccessCard(
                title: context.t('requestSent'),
                subtitle: context.t('underReview'),
              ),
              const SizedBox(height: 14),
              BookingRequestSummaryCard(request: request),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final bloc = context.read<BookingRequestBloc>();

                    Navigator.of(context).push(
                      BookingRequestRoutes.bookingStatus(
                        bloc: bloc,
                        bookingId: request.bookingId,
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    context.t('viewBookingStatus'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // مكانها الحقيقي: Navigator.popUntil(Home)
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    side: const BorderSide(color: AppColors.inputBorder),
                  ),
                  child: Text(context.t('goHome')),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SuccessCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.approvedBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.approvedBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.approvedText),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textDark, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

