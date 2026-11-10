import 'package:flutter/material.dart';

/// Official Karigaar Vector Brand Emblem (F-34: karigaar_app_icon_logo)
/// Renders the Deep Guild Slate squircle (#0F172A), Artisan Amber hexagon crest (#F59E0B),
/// plumb line & center dot, and Verified Emerald checkmark (#10B981).
class KarigaarBrandLogo extends StatelessWidget {
  final double size;

  const KarigaarBrandLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _KarigaarLogoPainter(),
      ),
    );
  }
}

class _KarigaarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100.0;

    // 1. Squircle background (#0F172A, rx=24)
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(24 * scale),
      ),
      bgPaint,
    );

    // 2. Hexagon Crest (M50 20L74 34V66L50 80L26 66V34L50 20Z)
    final hexPath = Path()
      ..moveTo(50 * scale, 20 * scale)
      ..lineTo(74 * scale, 34 * scale)
      ..lineTo(74 * scale, 66 * scale)
      ..lineTo(50 * scale, 80 * scale)
      ..lineTo(26 * scale, 66 * scale)
      ..lineTo(26 * scale, 34 * scale)
      ..close();

    final hexFillPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    canvas.drawPath(hexPath, hexFillPaint);

    final hexStrokePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(hexPath, hexStrokePaint);

    // 3. Plumb line (M50 28V40) & center circle (cx=50, cy=50, r=3)
    final plumbPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(50 * scale, 28 * scale),
      Offset(50 * scale, 40 * scale),
      plumbPaint,
    );

    final dotPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(50 * scale, 50 * scale), 3 * scale, dotPaint);

    // 4. Verified Emerald Checkmark (M38 52L46 60L64 42)
    final checkPath = Path()
      ..moveTo(38 * scale, 52 * scale)
      ..lineTo(46 * scale, 60 * scale)
      ..lineTo(64 * scale, 42 * scale);
    final checkPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
