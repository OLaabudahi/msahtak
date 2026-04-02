import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../data/repos/analytics_repo_impl.dart';
import '../data/sources/analytics_firebase_source.dart';
import '../domain/usecases/export_report_usecase.dart';
import '../domain/usecases/get_analytics_usecase.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  static Widget withBloc() {
    final source = AnalyticsFirebaseSource();
    final repo = AnalyticsRepoImpl(source);
    return BlocProvider(
      create: (_) => AnalyticsBloc(
        getAnalytics: GetAnalyticsUseCase(repo),
        export: ExportReportUseCase(repo),
      )..add(const AnalyticsStarted()),
      child: const AnalyticsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            final d = state.data;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 390),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AdminAppBar(title: 'Analytics', subtitle: 'Track your performance'),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _KpiWide(
                                  iconBg: AdminColors.primaryBlue.withOpacity(0.15),
                                  icon: AdminIconMapper.users(),
                                  title: 'Average Occupancy',
                                  value: d?.occupancy ?? '--',
                                  delta: '+12%',
                                ),
                                const SizedBox(height: 12),
                                _KpiWide(
                                  iconBg: AdminColors.success.withOpacity(0.15),
                                  icon: AdminIconMapper.checkCircle(),
                                  title: 'Monthly Revenue',
                                  value: d?.revenue ?? '--',
                                  delta: '+8%',
                                ),
                                const SizedBox(height: 12),
                                _KpiWide(
                                  iconBg: AdminColors.primaryAmber.withOpacity(0.15),
                                  icon: AdminIconMapper.star(),
                                  title: 'Average Rating',
                                  value: d?.avgRating ?? '--',
                                  delta: '+0.2',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Weekly Bookings', style: AdminText.h2()),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AdminCard(
                              child: SizedBox(
                                height: 200,
                                child: _WeeklyBars(
                                  labels: d?.weekLabels ?? const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
                                  values: (d?.weekValues ?? const ['12','18','10','22','30','16','14'])
                                      .map((e) => double.tryParse(e) ?? 0)
                                      .toList(growable: false),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Top Performing Spaces', style: AdminText.h2()),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _TopSpaceTile(rank: 1, name: 'Downtown Hub', rating: '4.9', bookings: '145', revenue: '\$14,500'),
                                const SizedBox(height: 12),
                                _TopSpaceTile(rank: 2, name: 'Creative Studio', rating: '4.8', bookings: '128', revenue: '\$12,800'),
                                const SizedBox(height: 12),
                                _TopSpaceTile(rank: 3, name: 'Tech Center', rating: '4.7', bookings: '98', revenue: '\$9,800'),
                                const SizedBox(height: 12),
                                _TopSpaceTile(rank: 4, name: 'City Office', rating: '4.6', bookings: '87', revenue: '\$8,700'),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 390),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                              child: InkWell(
                                onTap: () => context.read<AnalyticsBloc>().add(const AnalyticsExportPressed()),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AdminColors.primaryBlue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(AdminIconMapper.export(), size: 18, color: Colors.white),
                                      const SizedBox(width: 10),
                                      Text('Export Report', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(color: Colors.white, w: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                  ),
                ),

                
               /* Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Center(
                      child:
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 390),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: InkWell(
                            onTap: () => context.read<AnalyticsBloc>().add(const AnalyticsExportPressed()),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: AdminColors.primaryBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(AdminIconMapper.export(), size: 18, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text('Export Report', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(color: Colors.white, w: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ), ),
                  ),
                ),*/
              ],
            );
          },
        ),
      ),
    );
  }
}

class _KpiWide extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final String value;
  final String delta;

  const _KpiWide({
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.value,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AdminColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(delta, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.success, w: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  const _WeeklyBars({required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final maxV = values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(labels.length, (i) {
              final v = values[i];
              final h = (maxV <= 0) ? 0.0 : (v / maxV) * 140.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: AdminColors.primaryBlue.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(labels.length, (i) {
            return Expanded(
              child: Center(
                child: Text(labels[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TopSpaceTile extends StatelessWidget {
  final int rank;
  final String name;
  final String rating;
  final String bookings;
  final String revenue;

  const _TopSpaceTile({
    required this.rank,
    required this.name,
    required this.rating,
    required this.bookings,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AdminColors.black10,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text('$rank', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.text, w: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(AdminIconMapper.star(), size: 14, color: AdminColors.primaryAmber),
                        const SizedBox(width: 6),
                        Text(rating, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminColors.black02,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.black10, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bookings', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(bookings, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.success.withOpacity(0.15), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Revenue', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(revenue, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


