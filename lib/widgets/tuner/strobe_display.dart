import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';

/// Premium stroboskopik display — yumuşak kenarlar, derinlik efekti.
class StrobeDisplay extends StatefulWidget {
  final double cents;
  final bool isActive;

  const StrobeDisplay({
    super.key,
    required this.cents,
    this.isActive = false,
  });

  @override
  State<StrobeDisplay> createState() => _StrobeDisplayState();
}

class _StrobeDisplayState extends State<StrobeDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateOffset);

    if (widget.isActive) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant StrobeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  void _updateOffset() {
    setState(() {
      final speed = widget.cents * 0.15;
      _offset += speed;
      if (_offset.abs() > 100) _offset = _offset % 100;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.0, 0.12, 0.88, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: CustomPaint(
              painter: _StrobePainter(
                offset: _offset,
                isActive: widget.isActive,
                isInTune: widget.cents.abs() <= 3.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StrobePainter extends CustomPainter {
  final double offset;
  final bool isActive;
  final bool isInTune;

  _StrobePainter({
    required this.offset,
    required this.isActive,
    required this.isInTune,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.background,
    );

    if (!isActive) {
      _drawBands(canvas, size, 0, AppColors.textMuted.withValues(alpha: 0.08));
      return;
    }

    final color = isInTune
        ? AppColors.inTune.withValues(alpha: 0.7)
        : AppColors.textPrimary.withValues(alpha: 0.5);

    _drawBands(canvas, size, offset, color);

    // Orta referans çizgisi
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = AppColors.inTune.withValues(alpha: 0.2)
        ..strokeWidth = 1,
    );
  }

  void _drawBands(Canvas canvas, Size size, double off, Color color) {
    const bandWidth = 18.0;
    const gapWidth = 18.0;
    const totalWidth = bandWidth + gapWidth;
    const rows = 3;
    final rowHeight = size.height / rows;
    for (int row = 0; row < rows; row++) {
      final rowOffset = off * (1.0 + row * 0.25);
      final y = row * rowHeight;
      // Derinlik efekti: orta satır daha parlak
      final rowOpacity = row == 1 ? 1.0 : 0.6;

      for (double x = -totalWidth + (rowOffset % totalWidth);
          x < size.width + totalWidth;
          x += totalWidth) {
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y + 2, bandWidth, rowHeight - 4),
          const Radius.circular(3),
        );
        canvas.drawRRect(
          rrect,
          Paint()..color = color.withValues(alpha: color.a * rowOpacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StrobePainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isInTune != isInTune;
  }
}
