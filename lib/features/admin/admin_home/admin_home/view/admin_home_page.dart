import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/admin_home_bloc.dart';
import '../bloc/admin_home_event.dart';
import '../bloc/admin_home_state.dart';
import '../data/repos/admin_home_repo_impl.dart';
import '../data/sources/admin_home_firebase_source.dart';
import '../domain/usecases/get_admin_home_kpis_usecase.dart';
import '../domain/usecases/get_admin_spaces_usecase.dart';
import '../domain/usecases/get_admin_recent_activity_usecase.dart';
import '../widgets/kpi_tile.dart';
import '../domain/entities/admin_activity_item.dart';
import '../../../bookings/booking_requests/view/booking_requests_page.dart';
import '../../../calendar/calendar_availability/view/calendar_availability_page.dart';
import '../../../offers/offers_management/view/offers_management_page.dart';
import '../../../reviews/reviews_reports/view/reviews_reports_page.dart';
import '../../../my_spaces/add_edit_space/view/add_edit_space_page.dart';
import '../../../sub_admins/view/sub_admins_page.dart';
import '../../../_shared/admin_session.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../../../../../features/language/bloc/language_bloc.dart';
import '../../../../../services/language_service.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  static Widget withBloc() {
    final source = AdminHomeFirebaseSource();
    final repo = AdminHomeRepoImpl(source);
    return BlocProvider(
      create: (_) => AdminHomeBloc(
        getSpaces: GetAdminSpacesUseCase(repo),
        getKpis: GetAdminHomeKpisUseCase(repo),
        getActivity: GetAdminRecentActivityUseCase(repo),
      )..add(const AdminHomeStarted()),
      child: const AdminHomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      floatingActionButton: FloatingActionButton(
        heroTag: 'admin_home_fab',
        backgroundColor: AdminColors.primaryAmber,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddEditSpacePage.withBloc(spaceId: null)),
        ),
        child: Icon(AdminIconMapper.plus(), color: Colors.white),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<AdminHomeBloc, AdminHomeState>(
          builder: (context, state) {
            final hasSpace = state.activeSpaceId.isNotEmpty;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.t('adminDashboardTitle'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.h1()),
                        const SizedBox(height: 4),
                        Text(context.t('adminDashboardSubtitle'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14()),

                        const SizedBox(height: 16),
                        Text(context.t('adminSelectedSpace'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w600)),
                        const SizedBox(height: 8),

                        
                        InkWell(
                          onTap: state.spaces.isEmpty
                              ? null
                              : () async {
                                  final lang = context.read<LanguageBloc>().state.code;
                                  final selectSpaceTitle = LanguageService.tr(lang, 'adminSelectSpace');
                                  final picked = await showDialog<({String id, String name})>(
                                    context: context,
                                    barrierColor: const Color(0x66000000),
                                    builder: (_) => AlertDialog(
                                      backgroundColor: AdminColors.bg,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: Text(selectSpaceTitle, style: const TextStyle(fontFamily: 'SF Pro Text', fontWeight: FontWeight.w600)),
                                      content: SizedBox(
                                        width: 320,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: state.spaces.length,
                                          separatorBuilder: (_, __) => const Divider(height: 1, color: AdminColors.black15),
                                          itemBuilder: (ctx, i) {
                                            final s = state.spaces[i];
                                            return ListTile(
                                              title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w500)),
                                              onTap: () => Navigator.of(ctx).pop((id: s.id, name: s.name)),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );

                                  if (picked != null) {
                                    context.read<AdminHomeBloc>().add(AdminHomeSpaceChanged(spaceId: picked.id, spaceName: picked.name));
                                  }
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AdminColors.black15, width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    hasSpace ? state.activeSpaceName : context.t('adminSelectSpace'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AdminText.body16(w: FontWeight.w600),
                                  ),
                                ),
                                Icon(AdminIconMapper.chevronDown(), size: 18, color: AdminColors.black40),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                        InkWell(
                          onTap: hasSpace
                              ? () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => AddEditSpacePage.withBloc(spaceId: state.activeSpaceId)),
                                  )
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AdminColors.bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AdminColors.black15, width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AdminColors.black02,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AdminColors.black10, width: 1),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(AdminIconMapper.edit(), size: 16, color: AdminColors.primaryBlue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    hasSpace ? '${context.t('adminManage')} ${state.activeSpaceName}' : context.t('adminManage'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AdminText.body16(w: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(AdminIconMapper.chevronDown(), size: 18, color: AdminColors.black40),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        
                        LayoutBuilder(
                          builder: (context, c) {
                            final w = c.maxWidth;
                            final tileW = (w - 12) / 2;
                            final tileH = 112.0;
                            final ratio = tileW / tileH;

                            final items = state.kpis;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: ratio,
                              ),
                              itemBuilder: (_, i) => KpiTile(title: items[i].title, value: items[i].value, delta: items[i].delta),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        
                        Row(
                          children: [
                            Expanded(child: Text(context.t('adminRecentActivity'), style: AdminText.h2())),
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => BookingRequestsPage.withBloc()),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AdminColors.black02,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AdminColors.black10, width: 1),
                                ),
                                child: Text(context.t('adminMore'), maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.primaryBlue, w: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if (state.recentActivity.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: Text(context.t('adminNoRecentActivity'), style: AdminText.body14(color: AdminColors.black40))),
                          )
                        else
                          ...state.recentActivity.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ActivityCard(item: item),
                          )),

                        const SizedBox(height: 18),

                        
                        Text(context.t('adminQuickActions'), style: AdminText.h2()),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionBtn(
                                label: context.t('adminViewRequests'),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => BookingRequestsPage.withBloc()),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionBtn(
                                label: context.t('adminManageCalendar'),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => CalendarAvailabilityPage.withBloc(fromHome: true)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionBtn(
                                label: context.t('adminCreateOffer'),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => OffersManagementPage.withBloc(fromHome: true)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionBtn(
                                label: context.t('adminViewReviews'),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => ReviewsReportsPage.withBloc(fromHome: true)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (AdminSession.isSuperAdmin) ...[
                          const SizedBox(height: 12),
                          _QuickActionBtn(
                            label: context.t('adminManageSubAdmins'),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SubAdminsPage.withBloc()),
                            ),
                          ),
                        ],
                      ],
                    ),
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

class _ActivityCard extends StatelessWidget {
  final AdminActivityItem item;
  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    
    final action = '${context.t(item.actionKey)} ${item.spaceName}';

    
    final td = item.timeAgoData;
    final time = td.key == 'timeJustNow'
        ? context.t('timeJustNow')
        : '${td.n} ${context.t(td.key)}';

    return AdminCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.text, w: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(action, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40, w: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(time, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
        ],
      ),
    );
  }
}
class _QuickActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickActionBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AdminColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.black15, width: 1),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AdminText.body14(w: FontWeight.w700),
        ),
      ),
    );
  }
}
