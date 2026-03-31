import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

/// Yarım daire SVG-style cent göstergesi.
/// ♭ sol — ✓ üst merkez — ♯ sağ
class PitchGauge extends StatelessWidget {
  const PitchGauge({
    super.key,
    required this.cents,
    required this.isInTune,
    required this.isActive,
  });

  final double cents;
  final bool isInTune;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 160,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Statik ark + tick marks
          CustomPaint(
            size: const Size(280, 160),
            painter: _ArcPainter(isActive: isActive, isInTune: isInTune),
          ),
          // Cents badge
          if (isActive && cents != 0)
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  '${cents >= 0 ? '+' : ''}${cents.toStringAsFixed(0)} CENTS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isInTune ? AppColors.primaryContainer : AppColors.secondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.isActive, required this.isInTune});

  final bool isActive;
  final bool isInTune;

  static const double _r = 118.0;
  static const double _sw = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);

    // Arka plan yayı
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: _r),
      pi,
      pi,
      false,
      Paint()
        ..color = AppColors.surfaceContainerHighest
        ..style = PaintingStyle.stroke
        ..strokeWidth = _sw
        ..strokeCap = StrokeCap.round,
    );

    // Merkez tick (ana ✓ çizgisi)
    final centerAngle = pi + pi / 2;
    final t1 = center + Offset(cos(centerAngle) * (_r - 14), sin(centerAngle) * (_r - 14));
    final t2 = center + Offset(cos(centerAngle) * (_r + 6), sin(centerAngle) * (_r + 6));
    canvas.drawLine(
      t1, t2,
      Paint()
        ..color = AppColors.primaryContainer
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Yan tick'ler (-50, -25, +25, +50)
    for (final c in [-50, -25, 25, 50]) {
      final a = _centToAngle(c.toDouble());
      final inner = center + Offset(cos(a) * (_r - 8), sin(a) * (_r - 8));
      final outer = center + Offset(cos(a) * (_r + 4), sin(a) * (_r + 4));
      canvas.drawLine(inner, outer,
          Paint()
            ..color = AppColors.outlineVariant.withValues(alpha: 0.5)
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round);
    }

    // Etiketler: ♭ sol, ✓ üst, ♯ sağ
    _drawLabel(canvas, size, '♭', _centToAngle(-50), isLeft: true);
    _drawLabel(canvas, size, '♯', _centToAngle(50), isLeft: false);
  }

  void _drawLabel(Canvas canvas, Size size, String text, double angle, {required bool isLeft}) {
    final center = Offset(size.width / 2, size.height);
    final pos = center + Offset(cos(angle) * (_r + 20), sin(angle) * (_r + 20));
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 13,
          color: AppColors.secondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  double _centToAngle(double c) => pi + (c + 50) / 100.0 * pi;

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.isActive != isActive || old.isInTune != isInTune;
}
