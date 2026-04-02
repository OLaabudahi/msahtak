import 'package:flutter/material.dart';

/// رسام الدائرة التقدمية لدرجة التطابق
class FitScorePainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color fgColor;
  final double strokeWidth;

  const FitScorePainter({
    required this.progress,
    required this.bgColor,
    required this.fgColor,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 2;
    final innerRadius = outerRadius - strokeWidth;

    canvas.drawCircle(
      center,
      innerRadius,
      Paint()..color = fgColor..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      outerRadius - strokeWidth / 2,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(covariant FitScorePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
