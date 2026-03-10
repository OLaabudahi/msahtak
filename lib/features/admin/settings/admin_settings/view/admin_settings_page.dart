import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../../../../../features/app_start/bloc/app_start_bloc.dart';
import '../../../../../features/app_start/bloc/app_start_event.dart';
import '../../../../../services/local_storage_service.dart';

import '../bloc/admin_settings_bloc.dart';
import '../bloc/admin_settings_event.dart';
import '../bloc/admin_settings_state.dart';
import '../data/repos/admin_settings_repo_impl.dart';
import '../data/sources/admin_settings_local_source.dart';
import '../domain/usecases/logout_usecase.dart';
import '../widgets/settings_group.dart';

import '../../../analytics/analytics/view/analytics_performance_page.dart';
import '../../../analytics/analytics/view/analytics_top_spaces_page.dart';
import '../../../bookings/booking_requests/view/booking_requests_page.dart';
import '../../../calendar/calendar_availability/view/calendar_availability_page.dart';
import '../../../offers/offers_management/view/offers_management_page.dart';
import '../../../reviews/reviews_reports/view/reviews_reports_page.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  static Widget withBloc() {
    final source = AdminSettingsLocalSource(LocalStorageService());
    final repo = AdminSettingsRepoImpl(source);
    return BlocProvider(
      create: (_) => AdminSettingsBloc(logout: LogoutUseCase(repo)),
      child: const AdminSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocListener<AdminSettingsBloc, AdminSettingsState>(
          listenWhen: (p, n) => p.status != n.status,
          listener: (context, state) {
            if (state.status == AdminSettingsStatus.loggedOut) {
              // نطلب من AppStartBloc إعادة التحقق — سيرجع goLogin تلقائياً
              // ويعرض AppRoot.BlocBuilder صفحة الـ LoginPage الصحيحة
              context.read<AppStartBloc>().add(const AppStartStarted());
            }
            if (state.status == AdminSettingsStatus.failure && state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!), backgroundColor: AdminColors.danger),
              );
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Settings', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.h1()),
                      const SizedBox(height: 18),


                      SettingsGroup(
                        title: 'Analytics',
                        children: [
                          SettingsRow(
                            title: 'Performance',
                            subtitle: 'KPIs & weekly bookings',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalyticsPerformancePage.withBloc())),
                          ),
                          SettingsRow(
                            title: 'Top Spaces',
                            subtitle: 'Top performing + export',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalyticsTopSpacesPage.withBloc())),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ADMIN ACTIONS (quick actions)
                      SettingsGroup(
                        title: 'Admin actions',
                        children: [
                          SettingsRow(
                            title: 'View Requests',
                            subtitle: 'Pending/approved/canceled',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingRequestsPage.withBloc())),
                          ),
                          SettingsRow(
                            title: 'Manage Calendar',
                            subtitle: 'Closures & special hours',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CalendarAvailabilityPage.withBloc(fromHome: true))),
                          ),
                          SettingsRow(
                            title: 'Offers Management',
                            subtitle: 'Discounts & packages',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OffersManagementPage.withBloc(fromHome: true))),
                          ),
                          SettingsRow(
                            title: 'Reviews & Reports',
                            subtitle: 'Moderation & replies',
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReviewsReportsPage.withBloc(fromHome: true))),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // LOGOUT
                      SettingsGroup(
                        title: 'Account',
                        children: [
                          SettingsRow(
                            title: 'Logout',
                            subtitle: 'Sign out of admin account',
                            onTap: () => context.read<AdminSettingsBloc>().add(const AdminSettingsLogoutPressed()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
