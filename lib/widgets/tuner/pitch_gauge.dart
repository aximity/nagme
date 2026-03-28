import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

/// Premium yarım daire gauge — spring physics iğne, katmanlı tasarım.
class PitchGauge extends StatefulWidget {
  final double cents;
  final bool isActive;

  const PitchGauge({
    super.key,
    required this.cents,
    this.isActive = false,
  });

  @override
  State<PitchGauge> createState() => _PitchGaugeState();
}

class _PitchGaugeState extends State<PitchGauge>
    with TickerProviderStateMixin {
  late AnimationController _needleController;
  late AnimationController _glowController;
  double _currentCents = 0;
  double _targetCents = 0;
  bool _wasInTune = false;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          _currentCents = _needleController.value;
        });
      });

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.glowPulseDuration),
    );
  }

  @override
  void didUpdateWidget(covariant PitchGauge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isActive) {
      _needleController.stop();
      _glowController.stop();
      return;
    }

    if (widget.cents != _targetCents) {
      _targetCents = widget.cents;
      _animateNeedle(_currentCents, _targetCents);
    }

    final isInTune = widget.cents.abs() <= AppConstants.tuneThresholdCents;
    if (isInTune && !_wasInTune) {
      _glowController.forward(from: 0);
    }
    _wasInTune = isInTune;
  }

  void _animateNeedle(double from, double to) {
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: AppConstants.springStiffness,
      damping: AppConstants.springDamping * 2 * sqrt(AppConstants.springStiffness),
    );
    final simulation = SpringSimulation(spring, from, to, 0);
    _needleController.animateWith(simulation);
  }

  @override
  void dispose() {
    _needleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInTune =
        _currentCents.abs() <= AppConstants.tuneThresholdCents && widget.isActive;

    return RepaintBoundary(
      child: SizedBox(
        width: AppConstants.gaugeSize,
        height: AppConstants.gaugeSize * 0.55,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return CustomPaint(
              painter: _PremiumGaugePainter(
                cents: _currentCents,
                isActive: widget.isActive,
                isInTune: isInTune,
                glowProgress: _glowController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PremiumGaugePainter extends CustomPainter {
  final double cents;
  final bool isActive;
  final bool isInTune;
  final double glowProgress;

  _PremiumGaugePainter({
    required this.cents,
    required this.isActive,
    required this.isInTune,
    required this.glowProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 12);
    final radius = size.width / 2 - 28;

    // Katman 0: Dış glow halkası
    _drawOuterGlow(canvas, center, radius);

    // Katman 1: Arka plan yay — gradient
    _drawTrackArc(canvas, center, radius);

    // Katman 2: Tick işaretleri
    _drawTicks(canvas, center, radius);

    // Katman 3: ± etiketleri
    _drawLabels(canvas, center, radius);

    if (!isActive) return;

    // Katman 4: İğne
    _drawNeedle(canvas, center, radius);

    // Katman 5: Pivot noktası
    _drawPivot(canvas, center);

    // Katman 6: Akort glow pulse
    if (isInTune && glowProgress > 0 && glowProgress < 1) {
      _drawInTunePulse(canvas, center, radius);
    }
  }

  void _drawOuterGlow(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..color = (isInTune ? AppColors.inTune : AppColors.gaugeTrack)
          .withValues(alpha: isActive ? 0.06 : 0.02)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 12),
      pi,
      pi,
      false,
      glowPaint..style = PaintingStyle.stroke..strokeWidth = 20,
    );
  }

  void _drawTrackArc(Canvas canvas, Offset center, double radius) {
    // Ana track
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    trackPaint.shader = const SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: [
        Color(0xFF1A1A20),
        Color(0xFF2A2A32),
        Color(0xFF2E2E38),
        Color(0xFF2A2A32),
        Color(0xFF1A1A20),
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    ).createShader(rect);

    canvas.drawArc(rect, pi, pi, false, trackPaint);

    // İnce iç çizgi (derinlik)
    final innerLinePaint = Paint()
      ..color = const Color(0xFF0D0D10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      pi * 1.02,
      pi * 0.96,
      false,
      innerLinePaint,
    );
  }

  void _drawTicks(Canvas canvas, Offset center, double radius) {
    // Ana tick'ler: -50, -25, 0, +25, +50
    final majorTicks = [-50.0, -25.0, 0.0, 25.0, 50.0];
    // Minör tick'ler
    final minorTicks = [-37.5, -12.5, 12.5, 37.5];

    for (final tick in majorTicks) {
      final angle = _centsToAngle(tick);
      final isCenterMark = tick == 0;

      final length = isCenterMark ? 14.0 : 10.0;
      final width = isCenterMark ? 2.5 : 1.5;
      final color = isCenterMark
          ? AppColors.inTune.withValues(alpha: 0.8)
          : AppColors.textMuted.withValues(alpha: 0.6);

      final outer = Offset(
        center.dx + (radius + 8) * cos(angle),
        center.dy + (radius + 8) * sin(angle),
      );
      final inner = Offset(
        center.dx + (radius + 8 - length) * cos(angle),
        center.dy + (radius + 8 - length) * sin(angle),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = color
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    for (final tick in minorTicks) {
      final angle = _centsToAngle(tick);
      final outer = Offset(
        center.dx + (radius + 6) * cos(angle),
        center.dy + (radius + 6) * sin(angle),
      );
      final inner = Offset(
        center.dx + (radius) * cos(angle),
        center.dy + (radius) * sin(angle),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = AppColors.textMuted.withValues(alpha: 0.3)
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    // - ve + etiketleri
    final labelStyle = TextStyle(
      color: AppColors.textMuted.withValues(alpha: 0.5),
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

    _drawText(canvas, '−', Offset(center.dx - radius - 4, center.dy - 18), labelStyle);
    _drawText(canvas, '+', Offset(center.dx + radius - 2, center.dy - 18), labelStyle);
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position);
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final clampedCents = cents.clamp(
      -AppConstants.maxCentsDisplay,
      AppConstants.maxCentsDisplay,
    );
    final needleAngle = _centsToAngle(clampedCents);

    final needleLength = radius - 8;
    final needleEnd = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    // İğne gölgesi
    canvas.drawLine(
      Offset(center.dx + 1, center.dy + 1),
      Offset(needleEnd.dx + 1, needleEnd.dy + 1),
      Paint()
        ..color = const Color(0x30000000)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Konik iğne (path ile)
    final needleColor = isInTune ? AppColors.inTune : AppColors.needleColor;
    final perpAngle = needleAngle + pi / 2;
    const baseWidth = 3.0;
    const tipWidth = 0.8;

    final path = Path()
      ..moveTo(
        center.dx + baseWidth * cos(perpAngle),
        center.dy + baseWidth * sin(perpAngle),
      )
      ..lineTo(
        needleEnd.dx + tipWidth * cos(perpAngle),
        needleEnd.dy + tipWidth * sin(perpAngle),
      )
      ..lineTo(
        needleEnd.dx - tipWidth * cos(perpAngle),
        needleEnd.dy - tipWidth * sin(perpAngle),
      )
      ..lineTo(
        center.dx - baseWidth * cos(perpAngle),
        center.dy - baseWidth * sin(perpAngle),
      )
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = needleColor
        ..style = PaintingStyle.fill,
    );

    // İğne ucu glow (akortluyken)
    if (isInTune) {
      canvas.drawCircle(
        needleEnd,
        4,
        Paint()
          ..color = AppColors.inTune.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  void _drawPivot(Canvas canvas, Offset center) {
    // Dış halka
    canvas.drawCircle(
      center,
      7,
      Paint()
        ..color = isInTune ? AppColors.inTune.withValues(alpha: 0.3) : const Color(0xFF2A2A30)
        ..style = PaintingStyle.fill,
    );

    // İç nokta
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = isInTune ? AppColors.inTune : AppColors.needleColor
        ..style = PaintingStyle.fill,
    );

    // Parlak nokta (metalik his)
    canvas.drawCircle(
      Offset(center.dx - 1, center.dy - 1),
      1.5,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawInTunePulse(Canvas canvas, Offset center, double radius) {
    final progress = Curves.easeOut.transform(glowProgress);
    final pulseRadius = radius * (0.3 + progress * 0.7);
    final opacity = (1.0 - progress) * 0.15;

    canvas.drawCircle(
      center,
      pulseRadius,
      Paint()
        ..color = AppColors.inTune.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  double _centsToAngle(double cents) {
    final normalized = cents / AppConstants.maxCentsDisplay;
    return pi + (normalized + 1) * pi / 2;
  }

  @override
  bool shouldRepaint(covariant _PremiumGaugePainter oldDelegate) {
    return oldDelegate.cents != cents ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isInTune != isInTune ||
        oldDelegate.glowProgress != glowProgress;
  }
}
