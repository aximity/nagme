import 'dart:math';
import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final Color color;
  final double phase;
  final double amplitude;
  final bool showDashed;
  final Color? dashedColor;

  WaveformPainter({
    required this.color,
    this.phase = 0,
    this.amplitude = 0.35,
    this.showDashed = false,
    this.dashedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    final amp = size.height * amplitude;
    final wFactor = 4 * pi / size.width;

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 2) {
      final y = midY + amp * sin(x * wFactor + phase);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);

    if (showDashed) {
      final dashedPaint = Paint()
        ..color = (dashedColor ?? color).withValues(alpha: 0.4)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final dashedPath = Path();
      final ampDashed = amp * 0.7;
      final phaseDashed = phase + 0.5;
      dashedPath.moveTo(0, midY);
      for (double x = 0; x <= size.width; x += 2) {
        final y = midY + ampDashed * sin(x * wFactor + phaseDashed);
        dashedPath.lineTo(x, y);
      }

      const dashWidth = 4.0;
      const dashSpace = 4.0;
      final metric = dashedPath.computeMetrics().first;
      double distance = 0;
      while (distance < metric.length) {
        final end = min(distance + dashWidth, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end),
          dashedPaint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) =>
      color != oldDelegate.color ||
      phase != oldDelegate.phase ||
      amplitude != oldDelegate.amplitude ||
      showDashed != oldDelegate.showDashed;
}

class GridPainter extends CustomPainter {
  final Color color;

  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      color != oldDelegate.color;
}
