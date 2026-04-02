import 'package:flutter/material.dart';

class MsahtakLogo extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;

  const MsahtakLogo({
    Key? key,
    this.width = 250,
    this.height = 100,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          Positioned(
            left: 0,
            child: CustomPaint(
              size: Size(height * 0.8, height * 0.8),
              painter: MsahtakMPainter(),
            ),
          ),
          
          Positioned(
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sahtak',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003B73),
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'ظ…ط³ط§ط­طھظƒ',
                  style: TextStyle(
                    fontSize: fontSize * 0.65,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003B73),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MsahtakMPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    
    final headPaint = Paint()
      ..color = const Color(0xFFFFA726)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.15),
      size.width * 0.08,
      headPaint,
    );

    
    paint.color = const Color(0xFF003B73);

    final path = Path();

    
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.95),
      size.width * 0.08,
      Paint()
        ..color = const Color(0xFF003B73)
        ..style = PaintingStyle.fill,
    );
    path.moveTo(size.width * 0.15, size.height * 0.95);
    path.lineTo(size.width * 0.15, size.height * 0.5);

    
    path.lineTo(size.width * 0.35, size.height * 0.35);

    
    path.lineTo(size.width * 0.5, size.height * 0.28);

    
    path.lineTo(size.width * 0.65, size.height * 0.35);

    
    path.lineTo(size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width * 0.85, size.height * 0.95);

    
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.95),
      size.width * 0.08,
      Paint()
        ..color = const Color(0xFF003B73)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
