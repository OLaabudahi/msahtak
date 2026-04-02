import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/reviews_reports_bloc.dart';
import '../bloc/reviews_reports_event.dart';
import '../bloc/reviews_reports_state.dart';
import '../data/repos/reviews_reports_repo_impl.dart';
import '../data/sources/reviews_reports_firebase_source.dart';
import '../domain/usecases/get_reports_usecase.dart';
import '../domain/usecases/get_reviews_usecase.dart';
import '../domain/usecases/hide_review_usecase.dart';
import '../domain/usecases/reply_review_usecase.dart';

class ReviewsReportsPage extends StatelessWidget {
  final bool fromHome;
  const ReviewsReportsPage({super.key, required this.fromHome});

  static Widget withBloc({bool fromHome = false}) {
    final source = ReviewsReportsFirebaseSource();
    final repo = ReviewsReportsRepoImpl(source);
    return BlocProvider(
      create: (_) => ReviewsReportsBloc(
        getReviews: GetReviewsUseCase(repo),
        getReports: GetReportsUseCase(repo),
        hideReview: HideReviewUseCase(repo),
        replyReview: ReplyReviewUseCase(repo),
      )..add(const ReviewsReportsStarted()),
      child: ReviewsReportsPage(fromHome: fromHome),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<ReviewsReportsBloc, ReviewsReportsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Reviews & Reports', style: AdminText.h1())),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Manage feedback and issues', style: AdminText.body14()),

                        const SizedBox(height: 16),

                        
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: AdminColors.black15, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _SegTab(
                                label: 'Reviews',
                                active: state.tab == 0,
                                onTap: () => context.read<ReviewsReportsBloc>().add(const ReviewsReportsTabChanged(0)),
                              ),
                              const SizedBox(width: 6),
                              _SegTab(
                                label: 'Reports',
                                active: state.tab == 1,
                                onTap: () => context.read<ReviewsReportsBloc>().add(const ReviewsReportsTabChanged(1)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (state.tab == 0)
                          Column(
                            children: state.reviews.map((r) {
                              final initials = _initials(r.userName);
                              final stars = int.tryParse(r.stars) ?? 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AdminCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AdminColors.primaryBlue,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              initials,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AdminText.body14(color: Colors.white, w: FontWeight.w700),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(r.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
                                                    ),
                                                    Text(r.dateLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(r.spaceName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40)),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: List.generate(5, (i) {
                                                    final filled = i < stars;
                                                    return Padding(
                                                      padding: const EdgeInsets.only(right: 3),
                                                      child: Icon(
                                                        AdminIconMapper.star(),
                                                        size: 14,
                                                        color: filled ? AdminColors.primaryAmber : AdminColors.black15,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),
                                      Text(r.text, style: AdminText.body14(color: AdminColors.black75), maxLines: 4, overflow: TextOverflow.ellipsis),

                                      if (r.adminReply != null && r.adminReply!.trim().isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Text('Your Reply:', style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w700)),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AdminColors.black15, width: 1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            r.adminReply!,
                                            style: AdminText.body14(color: AdminColors.text, w: FontWeight.w600),
                                          ),
                                        ),
                                      ],

                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                final reply = await _askReply(context);
                                                if (reply != null && reply.trim().isNotEmpty) {
                                                  context.read<ReviewsReportsBloc>().add(ReviewsReportsReplyPressed(r.id, reply.trim()));
                                                }
                                              },
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: AdminColors.primaryBlue,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(AdminIconMapper.mail(), size: 16, color: Colors.white),
                                                    const SizedBox(width: 8),
                                                    Text('Reply', style: AdminText.body14(color: Colors.white, w: FontWeight.w700)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => context.read<ReviewsReportsBloc>().add(ReviewsReportsHidePressed(r.id)),
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AdminColors.black15, width: 1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(AdminIconMapper.hide(), size: 16, color: AdminColors.black40),
                                                    const SizedBox(width: 8),
                                                    Text('Hide', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(growable: false),
                          )
                        else
                          Column(
                            children: state.reports
                                .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AdminCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.subject, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w700)),
                                    const SizedBox(height: 8),
                                    Text('Reason: ${p.reason}', maxLines: 2, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                                  ],
                                ),
                              ),
                            ))
                                .toList(growable: false),
                          ),

                        const SizedBox(height: 32),
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

  
  static Future<String?> _askReply(BuildContext context) async {
    String text = '';
    return showDialog<String>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AdminColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reply', style: AdminText.body16(w: FontWeight.w700)),
        content: TextField(
          maxLines: 3,
          style: AdminText.body16(),
          onChanged: (v) => text = v,
          decoration: InputDecoration(
            hintText: 'Write your reply...',
            hintStyle: AdminText.body16(color: AdminColors.black40),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(null),
            child: Text('Cancel', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(text),
            child: Text('Send', style: AdminText.body14(color: AdminColors.primaryBlue, w: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    final a = parts.first.isNotEmpty ? parts.first[0] : 'U';
    final b = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }
}

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: active ? AdminColors.primaryBlue.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? AdminColors.primaryBlue : AdminColors.black15, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AdminText.body14(color: active ? AdminColors.primaryBlue : AdminColors.black75, w: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
