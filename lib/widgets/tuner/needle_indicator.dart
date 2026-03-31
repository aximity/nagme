import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nagme/config/theme.dart';

class NeedleIndicator extends StatefulWidget {
  const NeedleIndicator({
    super.key,
    required this.cents,
    required this.isInTune,
    required this.isActive,
  });

  final double cents;
  final bool isInTune;
  final bool isActive;

  @override
  State<NeedleIndicator> createState() => _NeedleIndicatorState();
}

class _NeedleIndicatorState extends State<NeedleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Hafif underdamped spring — hızlı snap, küçük zıplama
  static final _spring = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 200.0,
    ratio: 0.62,
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController.unbounded(vsync: this);
  }

  @override
  void didUpdateWidget(NeedleIndicator old) {
    super.didUpdateWidget(old);

    // Tuner yeniden aktif olduğunda ibrenin sıfırdan başlaması
    if (!old.isActive && widget.isActive) {
      _ctrl.value = 0;
    }

    if (widget.isActive && old.cents != widget.cents) {
      _ctrl.animateWith(SpringSimulation(
        _spring,
        _ctrl.value,       // anlık pozisyon
        widget.cents,      // hedef
        _ctrl.velocity,    // anlık hız (zincirleme spring için)
      ));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox(width: 280, height: 160);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: const Size(280, 160),
        painter: _NeedlePainter(cents: _ctrl.value, isInTune: widget.isInTune),
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  const _NeedlePainter({required this.cents, required this.isInTune});

  final double cents;
  final bool isInTune;

  static const double _r = 118.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    // Spring biraz aşabilir — ±60 sınırı ile gauge dışına fazla çıkmasın
    final angle = _centToAngle(cents.clamp(-60.0, 60.0));
    final color = isInTune ? AppColors.primaryContainer : AppColors.secondary;

    // Glow (sadece akortluysa)
    if (isInTune) {
      canvas.drawLine(
        center + Offset(cos(angle) * 18, sin(angle) * 18),
        center + Offset(cos(angle) * (_r - 6), sin(angle) * (_r - 6)),
        Paint()
          ..color = AppColors.primaryContainer.withValues(alpha: 0.25)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // İbre
    canvas.drawLine(
      center + Offset(cos(angle) * 18, sin(angle) * 18),
      center + Offset(cos(angle) * (_r - 6), sin(angle) * (_r - 6)),
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Merkez daire
    canvas.drawCircle(center, 9, Paint()..color = AppColors.surfaceContainerHigh);
    canvas.drawCircle(center, 6, Paint()..color = color);
  }

  double _centToAngle(double c) => pi + (c + 50) / 100.0 * pi;

  @override
  bool shouldRepaint(_NeedlePainter old) =>
      old.cents != cents || old.isInTune != isInTune;
}
