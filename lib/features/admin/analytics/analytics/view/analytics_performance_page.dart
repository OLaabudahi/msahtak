import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../data/repos/analytics_repo_impl.dart';
import '../data/sources/analytics_firebase_source.dart';
import '../domain/usecases/get_analytics_usecase.dart';
import '../domain/usecases/export_report_usecase.dart';

class AnalyticsPerformancePage extends StatelessWidget {
  const AnalyticsPerformancePage({super.key});

  static Widget withBloc() {
    final source = AnalyticsFirebaseSource();
    final repo = AnalyticsRepoImpl(source);
    return BlocProvider(
      create: (_) => AnalyticsBloc(
        getAnalytics: GetAnalyticsUseCase(repo),
        export: ExportReportUseCase(repo),
      )..add(const AnalyticsStarted()),
      child: const AnalyticsPerformancePage(),
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
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminAppBar(
                        title: 'Analytics',
                        subtitle: 'Performance',
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
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
