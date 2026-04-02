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

class AnalyticsTopSpacesPage extends StatelessWidget {
  const AnalyticsTopSpacesPage({super.key});

  static Widget withBloc() {
    final source = AnalyticsFirebaseSource();
    final repo = AnalyticsRepoImpl(source);
    return BlocProvider(
      create: (_) => AnalyticsBloc(
        getAnalytics: GetAnalyticsUseCase(repo),
        export: ExportReportUseCase(repo),
      )..add(const AnalyticsStarted()),
      child: const AnalyticsTopSpacesPage(),
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
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 390),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminAppBar(
                            title: 'Analytics',
                            subtitle: 'Top Spaces',
                            onBack: () => Navigator.of(context).maybePop(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                const _TopSpaceTile(rank: 1, name: 'Downtown Hub', rating: '4.9', bookings: '145', revenue: '\$14,500'),
                                const SizedBox(height: 12),
                                const _TopSpaceTile(rank: 2, name: 'Creative Studio', rating: '4.8', bookings: '128', revenue: '\$12,800'),
                                const SizedBox(height: 12),
                                const _TopSpaceTile(rank: 3, name: 'Tech Center', rating: '4.7', bookings: '98', revenue: '\$9,800'),
                                const SizedBox(height: 12),
                                const _TopSpaceTile(rank: 4, name: 'City Office', rating: '4.6', bookings: '87', revenue: '\$8,700'),
                                const SizedBox(height: 12),
                                InkWell(
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

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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


