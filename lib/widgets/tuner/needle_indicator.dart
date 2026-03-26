import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/config/constants.dart';

/// Animasyonlu iğne göstergesi — spring physics ile smooth hareket.
class NeedleIndicator extends StatefulWidget {
  final double cents;
  final bool isActive;

  const NeedleIndicator({
    super.key,
    required this.cents,
    this.isActive = false,
  });

  @override
  State<NeedleIndicator> createState() => _NeedleIndicatorState();
}

class _NeedleIndicatorState extends State<NeedleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentCents = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: AppConstants.needleAnimDuration),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant NeedleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cents != widget.cents) {
      _animation = Tween<double>(
        begin: _currentCents,
        end: widget.cents,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        _currentCents = _animation.value;
        final isInTune =
            _currentCents.abs() <= AppConstants.tuneThresholdCents;

        return SizedBox(
          width: 280,
          height: 160,
          child: CustomPaint(
            painter: _NeedlePainter(
              cents: _currentCents,
              isActive: widget.isActive,
              isInTune: isInTune,
            ),
          ),
        );
      },
    );
  }
}

class _NeedlePainter extends CustomPainter {
  final double cents;
  final bool isActive;
  final bool isInTune;

  _NeedlePainter({
    required this.cents,
    required this.isActive,
    required this.isInTune,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2 - 20;

    final clampedCents = cents.clamp(
      -AppConstants.maxCentsDisplay,
      AppConstants.maxCentsDisplay,
    );
    final normalizedPosition =
        clampedCents / AppConstants.maxCentsDisplay;
    final needleAngle = pi + (normalizedPosition + 1) * pi / 2;

    // İğne gölge
    final shadowPaint = Paint()
      ..color = (isInTune ? AppColors.inTune : AppColors.needleColor)
          .withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final needleEnd = Offset(
      center.dx + (radius - 15) * cos(needleAngle),
      center.dy + (radius - 15) * sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, shadowPaint);

    // İğne
    final needlePaint = Paint()
      ..color = isInTune ? AppColors.inTune : AppColors.needleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) {
    return oldDelegate.cents != cents ||
        oldDelegate.isActive != isActive;
  }
}
