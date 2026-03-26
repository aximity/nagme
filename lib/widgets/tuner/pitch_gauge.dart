import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

/// Yarım daire cent gauge — analog VU meter hissi.
class PitchGauge extends StatelessWidget {
  final double cents;
  final bool isActive;

  const PitchGauge({
    super.key,
    required this.cents,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 160,
      child: CustomPaint(
        painter: _GaugePainter(
          cents: cents,
          isActive: isActive,
          isInTune: cents.abs() <= AppConstants.tuneThresholdCents,
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double cents;
  final bool isActive;
  final bool isInTune;

  _GaugePainter({
    required this.cents,
    required this.isActive,
    required this.isInTune,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 20;

    // Gauge arka plan yayı
    final trackPaint = Paint()
      ..color = AppColors.gaugeTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // 180° (sol)
      pi, // 180° süpürme
      false,
      trackPaint,
    );

    // Orta işareti (akort noktası)
    final centerMarkPaint = Paint()
      ..color = AppColors.inTune.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(center.dx, center.dy - radius - 8),
      Offset(center.dx, center.dy - radius + 8),
      centerMarkPaint,
    );

    // Çeyrek işaretleri (-25, +25 cent)
    final tickPaint = Paint()
      ..color = AppColors.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final tick in [-25.0, -12.5, 12.5, 25.0]) {
      final angle = pi + (tick / AppConstants.maxCentsDisplay + 1) * pi / 2;
      final outer = Offset(
        center.dx + (radius + 6) * cos(angle),
        center.dy + (radius + 6) * sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - 6) * cos(angle),
        center.dy + (radius - 6) * sin(angle),
      );
      canvas.drawLine(outer, inner, tickPaint);
    }

    if (!isActive) return;

    // İğne açısı: -50 cent = sol (pi), 0 = üst (3pi/2), +50 = sağ (2pi)
    final clampedCents = cents.clamp(
      -AppConstants.maxCentsDisplay,
      AppConstants.maxCentsDisplay,
    );
    final normalizedPosition =
        clampedCents / AppConstants.maxCentsDisplay; // -1..+1
    final needleAngle = pi + (normalizedPosition + 1) * pi / 2;

    // İğne
    final needlePaint = Paint()
      ..color = isInTune ? AppColors.inTune : AppColors.needleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + (radius - 15) * cos(needleAngle),
      center.dy + (radius - 15) * sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // İğne pivot noktası
    final pivotPaint = Paint()
      ..color = isInTune ? AppColors.inTune : AppColors.needleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, pivotPaint);

    // Akort glow efekti
    if (isInTune) {
      final glowPaint = Paint()
        ..color = AppColors.inTuneGlow
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawCircle(center, 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.cents != cents ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isInTune != isInTune;
  }
}
