import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_spacing.dart';
import '../../booking_details/view/booking_details_page.dart';
import '../bloc/bookings_bloc.dart';
import '../bloc/bookings_event.dart';
import '../bloc/bookings_state.dart';
import '../widgets/booking_list_item.dart';
import '../widgets/bookings_segmented.dart';

class BookingTabPage extends StatelessWidget {
  const BookingTabPage({super.key});

  /// ✅ دالة: فتح التاب مع الـ Bloc
  static Widget withBloc() {
    return BlocProvider(
      create: (_) => BookingsBloc()..add(const BookingsStarted()),
      child: const BookingTabPage(),
    );
  }

  /// ✅ دالة: تفتح تفاصيل الحجز
  void _openBookingDetails(BuildContext context, String bookingId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingDetailsPage.withBloc(bookingId: bookingId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      /// ✅ دالة: بناء واجهة Bookings
      builder: (context, state) {
        final bloc = context.read<BookingsBloc>();
        final list = state.segmentIndex == 0 ? state.upcoming : state.past;

        return SafeArea(
          child: Padding(
            padding: AppSpacing.screen.copyWith(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bookings', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                AppSpacing.vMd,

                BookingsSegmented(
                  index: state.segmentIndex,
                  onChanged: (i) => bloc.add(BookingsSegmentChanged(i)),
                ),

                AppSpacing.vMd,

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => bloc.add(const BookingsRefreshRequested()),
                    child: state.loading
                        ? const Center(child: CircularProgressIndicator())
                        : (state.error != null)
                        ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text('صار خطأ: ${state.error}')),
                        const SizedBox(height: 12),
                        Center(
                          child: FilledButton(
                            onPressed: () => bloc.add(const BookingsStarted()),
                            child: const Text('Retry'),
                          ),
                        )
                      ],
                    )
                        : (list.isEmpty)
                        ? ListView(
                      children: const [
                        SizedBox(height: 140),
                        Center(child: Text('No bookings yet')),
                      ],
                    )
                        : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final b = list[i];
                        return BookingListItem(
                          booking: b,
                          onTap: () => _openBookingDetails(context, b.bookingId),
                        );
                      },
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
