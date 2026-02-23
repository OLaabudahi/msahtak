import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_text_styles.dart';
import '../bloc/bookings_bloc.dart';
import '../bloc/bookings_event.dart';
import '../bloc/bookings_state.dart';
import '../data/models/booking_model.dart';
import '../widgets/booking_list_item.dart';
import '../../booking_details/view/booking_details_page.dart';

class BookingsTabPage extends StatefulWidget {
  const BookingsTabPage({super.key});

  static Widget withBloc() {
    return BlocProvider(
      create: (_) => BookingsBloc()..add(const BookingsStarted()),
      child: const BookingsTabPage(),
    );
  }

  @override
  State<BookingsTabPage> createState() => _BookingsTabPageState();
}

class _BookingsTabPageState extends State<BookingsTabPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openBookingDetails(BuildContext context, Booking booking) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            BookingDetailsPage.withBloc(bookingId: booking.bookingId),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [AppColors.amber, AppColors.secondary],
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'AI Concierge',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        final bloc = context.read<BookingsBloc>();

        if (state.loading)
          return const Center(child: CircularProgressIndicator());
        if (state.error != null)
          return Center(child: Text('Error: ${state.error}'));

        final list = state.bookings;

        final upcoming = list
            .where((b) => b.status.toLowerCase() == 'upcoming')
            .toList();
        final completed = list
            .where((b) => b.status.toLowerCase() == 'completed')
            .toList();
        final cancelled = list
            .where((b) => b.status.toLowerCase() == 'cancelled')
            .toList();

        // Search filter (UI فقط)
        final q = _search.text.trim().toLowerCase();
        List<Booking> filter(List<Booking> src) {
          if (q.isEmpty) return src;
          return src.where((b) {
            return b.spaceName.toLowerCase().contains(q) ||
                b.bookingId.toLowerCase().contains(q);
          }).toList();
        }

        final upcomingF = filter(upcoming);
        final completedF = filter(completed);
        final cancelledF = filter(cancelled);

        return RefreshIndicator(
          onRefresh: () async => bloc.add(const BookingsRefreshRequested()),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              const SizedBox(height: 6),
              const Text('Bookings', style: AppTextStyles.sectionBarTitle),
              const SizedBox(height: 14),
              _searchBar(),

              if (upcomingF.isNotEmpty) ...[
                _sectionTitle('Your Upcoming Bookings'),
                ...upcomingF.map(
                  (b) => BookingListItem(
                    booking: b,
                    onView: () => _openBookingDetails(context, b),
                    onCancel: () {
                      // ✅ منطق الإلغاء لازم يروح للـ Bloc (Event)
                      // bloc.add(BookingsCancelRequested(bookingId: b.bookingId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cancel (dummy)')),
                      );
                    },
                  ),
                ),
              ],

              if (completedF.isNotEmpty) ...[
                _sectionTitle('Past Bookings'),
                ...completedF.map(
                  (b) => BookingListItem(
                    booking: b,
                    onView: () => _openBookingDetails(context, b),
                    onRebook: () {
                      // ✅ منطق rebook يروح للـ Bloc (Event)
                      // bloc.add(BookingsRebookRequested(spaceId: b.spaceId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rebook (dummy)')),
                      );
                    },
                  ),
                ),
              ],

              if (cancelledF.isNotEmpty) ...[
                _sectionTitle('Cancelled Bookings'),
                ...cancelledF.map(
                  (b) => BookingListItem(
                    booking: b,
                    onView: () => _openBookingDetails(context, b),
                  ),
                ),
              ],

              if (upcomingF.isEmpty && completedF.isEmpty && cancelledF.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: Text('No bookings yet')),
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
