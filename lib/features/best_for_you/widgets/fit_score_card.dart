import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../domain/entities/fit_score.dart';
import 'fit_score_painter.dart';

class FitScoreCard extends StatefulWidget {
  final FitScore fitScore;
  final String goal;

  const FitScoreCard(
      {super.key, required this.fitScore, required this.goal});

  @override
  State<FitScoreCard> createState() => _FitScoreCardState();
}

class _FitScoreCardState extends State<FitScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(
            begin: 0, end: widget.fitScore.percentage)
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant FitScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fitScore.percentage !=
        widget.fitScore.percentage) {
      _animation = Tween<double>(
              begin: 0, end: widget.fitScore.percentage)
          .animate(CurvedAnimation(
              parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fit Score',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return SizedBox(
                    width: 95,
                    height: 95,
                    child: CustomPaint(
                      painter: FitScorePainter(
                        progress: _animation.value,
                        bgColor: AppColors.secondaryTint35,
                        fgColor: AppColors.amberTint55,
                        strokeWidth: 10,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_animation.value * 100).toInt()}%',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              'for ${widget.goal}',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Why this matches:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    ...widget.fitScore.reasons.map((r) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('â€¢ ',
                                  style:
                                      TextStyle(fontSize: 11)),
                              Expanded(
                                child: Text(r,
                                    style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 11)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


