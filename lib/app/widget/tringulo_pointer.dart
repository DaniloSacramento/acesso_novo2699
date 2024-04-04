import 'package:acessonovo/app/widget/app_color.dart';
import 'package:flutter/material.dart';

class TrianguloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = darkBlueColor;
    paint.style = PaintingStyle.fill;

    final fixedValue = size.width * 0.1;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, fixedValue)
      ..lineTo(size.width - fixedValue, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
