import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import '../bloc/calendar_state.dart';
import '../data/repos/calendar_repo_impl.dart';
import '../data/sources/calendar_firebase_source.dart';
import '../domain/usecases/get_day_usecase.dart';
import '../domain/usecases/save_day_usecase.dart';

class CalendarAvailabilityPage extends StatelessWidget {
  final bool fromHome;
  const CalendarAvailabilityPage({super.key, required this.fromHome});

  static Widget withBloc({bool fromHome = false}) {
    final source = CalendarFirebaseSource(spaceId: 'default');
    final repo = CalendarRepoImpl(source);
    return BlocProvider(
      create: (_) => CalendarBloc(
        getDay: GetDayUseCase(repo),
        saveDay: SaveDayUseCase(repo),
      )..add(const CalendarStarted('2026-03-01')),
      child: CalendarAvailabilityPage(fromHome: fromHome),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: 'Calendar & Availability',
                        subtitle: 'Monthly calendar + day controls',
                        onBack: fromHome ? () => Navigator.of(context).maybePop() : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Month View', style: AdminText.body16(w: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Container(
                                height: 280,
                                decoration: BoxDecoration(
                                  color: AdminColors.black02,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AdminColors.black10, width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text('Calendar (monthly)', style: AdminText.body14()),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: Text('Close the day', style: AdminText.body16(w: FontWeight.w600))),
                                  Switch(
                                    value: state.day?.closed ?? false,
                                    onChanged: (v) => context.read<CalendarBloc>().add(CalendarClosedToggled(v)),
                                    activeColor: AdminColors.primaryBlue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Special hours', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: TextEditingController(text: state.day?.specialHours ?? '')
                                  ..selection = TextSelection.collapsed(offset: (state.day?.specialHours ?? '').length),
                                onChanged: (v) => context.read<CalendarBloc>().add(CalendarSpecialHoursChanged(v)),
                                style: AdminText.body16(),
                                decoration: InputDecoration(
                                  hintText: 'e.g. 10:00 AM - 4:00 PM',
                                  hintStyle: AdminText.body16(color: AdminColors.black40),
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              AdminButton.filled(
                                label: 'Save changes',
                                onTap: () => context.read<CalendarBloc>().add(const CalendarSavePressed()),
                                bg: AdminColors.primaryBlue,
                              ),
                            ],
                          ),
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
}


