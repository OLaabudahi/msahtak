import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';


class FlagTagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 8, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
        path, Paint()..color = Colors.white..style = PaintingStyle.fill);

    final border = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 8, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(
      border,
      Paint()
        ..color = AppColors.danger
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
