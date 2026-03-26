import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';

/// Audio buffer'ı dalga formu olarak çizen CustomPainter.
class WaveformPainter extends CustomPainter {
  final Float32List? buffer;
  final Color color;

  WaveformPainter({
    this.buffer,
    this.color = AppColors.inTune,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (buffer == null || buffer!.isEmpty) {
      _drawFlatLine(canvas, size);
      return;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final centerY = size.height / 2;
    final amplitude = size.height / 2 * 0.8; // %80 alan kullan
    final step = buffer!.length / size.width;

    for (int i = 0; i < size.width.toInt(); i++) {
      final bufferIndex = (i * step).toInt().clamp(0, buffer!.length - 1);
      final sample = buffer![bufferIndex].clamp(-1.0, 1.0);
      final y = centerY - sample * amplitude;

      if (i == 0) {
        path.moveTo(i.toDouble(), y);
      } else {
        path.lineTo(i.toDouble(), y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawFlatLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerY = size.height / 2;
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.buffer != buffer || oldDelegate.color != color;
  }
}

/// Waveform widget — RepaintBoundary ile sarılı.
class WaveformDisplay extends StatelessWidget {
  final Float32List? buffer;
  final double height;

  const WaveformDisplay({
    super.key,
    this.buffer,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: WaveformPainter(buffer: buffer),
        ),
      ),
    );
  }
}
