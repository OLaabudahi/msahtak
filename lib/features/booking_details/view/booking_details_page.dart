import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_assets.dart';
import '../../../constants/app_spacing.dart';
import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../bloc/booking_details_bloc.dart';
import '../bloc/booking_details_event.dart';
import '../bloc/booking_details_state.dart';
import '../data/repos/booking_details_repo_firebase.dart';
import '../widgets/booking_chip.dart';
import '../widgets/booking_section_title.dart';

class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  /// ✅ دالة: فتح الصفحة مع Bloc جاهز (Dummy repo حالياً)
  static Widget withBloc({required String bookingId}) {
    return BlocProvider(
      create: (_) =>
          BookingDetailsBloc(repo: BookingDetailsRepoFirebase())
            ..add(BookingDetailsStarted(bookingId)),
      child: BookingDetailsPage(bookingId: bookingId),
    );
  }

  /// ✅ دالة: تنسيق السعر
  String _money(String currency, num v) => '$currency ${v.toStringAsFixed(1)}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
      /// ✅ دالة: بناء UI حسب حالة التحميل/البيانات
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          );
        }

        if (state.error != null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.t('bookingDetailsTitle'))),
            body: SafeArea(
              child: Padding(
                padding: AppSpacing.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('صار خطأ: ${state.error}', style: AppTextStyles.body),
                    AppSpacing.vMd,
                    FilledButton(
                      onPressed: () => context.read<BookingDetailsBloc>().add(
                        BookingDetailsStarted(bookingId),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final d = state.data!;
        final imageAsset = d.imageAsset ?? AppAssets.home;

        return Scaffold(
          appBar: AppBar(
            title: Text(d.spaceName, style: AppTextStyles.sectionBarTitle),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screen.copyWith(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المساحة
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(imageAsset, fit: BoxFit.cover),

                            // ✅ API READY (كومنت)
                            // child: d.imageUrl != null
                            //     ? Image.network(d.imageUrl!, fit: BoxFit.cover)
                            //     : Image.asset(imageAsset, fit: BoxFit.cover),
                          ),
                        ),

                        AppSpacing.vMd,

                        // اسم المساحة + تقييم
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(d.spaceName, style: AppTextStyles.h1),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Text(
                                  d.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(d.locationText, style: AppTextStyles.caption),

                        AppSpacing.vMd,

                        // Tags
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: d.tags
                              .map((t) => BookingChip(text: t))
                              .toList(),
                        ),

                        AppSpacing.vLg,

                        BookingSectionTitle(text: context.t('bookingInfoLabel')),
                        AppSpacing.vSm,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${context.t('bookingDateLabel')}: ${d.dateText}',
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${context.t('bookingTimeLabel')}: ${d.timeText}',
                                style: AppTextStyles.body,
                              ),
                            ],
                          ),
                        ),

                        AppSpacing.vLg,

                        BookingSectionTitle(text: context.t('bookingNotesLabel')),
                        AppSpacing.vSm,
                        Text(d.notes, style: AppTextStyles.body),

                        AppSpacing.vLg,

                        BookingSectionTitle(text: context.t('bookingTotalLabel')),
                        AppSpacing.vSm,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            _money(d.currency, d.totalPrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        AppSpacing.vXl,
                      ],
                    ),
                  ),
                ),

                // زر ثابت تحت
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        // ✅ لاحقاً: Cancel / Modify / Pay حسب التصميم اللي رح تبعتيه
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Action (placeholder)')),
                        );

                        // ✅ API READY (كومنت)
                        // await bookingRepo.cancelBooking(bookingId);
                      },
                      child: Text(context.t('manageBooking')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
