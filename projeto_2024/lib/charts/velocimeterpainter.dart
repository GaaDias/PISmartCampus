import 'package:flutter/material.dart';
import 'dart:math';

class VelocimeterPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  VelocimeterPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 // Increased thickness for background arc
      ..color = Colors.grey.shade300;

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25 // Increased thickness for filled arc
      ..color = Colors.blue;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw background arc for 180 degrees
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start angle (180 degrees in radians)
      pi, // Sweep angle (180 degrees in radians)
      false,
      paint,
    );

    // Draw filled arc based on speed
    final double sweepAngle = (speed / maxSpeed) * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start angle
      sweepAngle,
      false,
      fillPaint,
    );

    // Draw the values
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (double i = 0; i <= maxSpeed; i += maxSpeed / 10) {
      final angle = pi + (i / maxSpeed) * pi;
      final offset = Offset(
        center.dx + (radius + 40) * cos(angle),
        center.dy + (radius + 40) * sin(angle),
      );

      textPainter.text = TextSpan(
        text: i.toStringAsFixed(0),
        style: TextStyle(color: Colors.black, fontSize: 12),
      );

      textPainter.layout();
      final textOffset = Offset(
        offset.dx - textPainter.width / 2,
        offset.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
