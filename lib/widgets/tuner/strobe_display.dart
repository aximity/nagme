import 'package:flutter/material.dart';
import 'package:nagme/config/theme.dart';

/// Peterson benzeri stroboskopik tuner görüntüsü.
///
/// Yatay bantlar cent sapmasına göre kayar:
/// - Sola kayma = düşük (bemol)
/// - Sağa kayma = yüksek (diyez)
/// - Durağan = akortlu
///
/// Kayma hızı cent sapmasıyla orantılı — 0.1 cent hassasiyet hissi verir.
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
      duration: const Duration(milliseconds: 16), // ~60fps
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
      // Cent sapması → kayma hızı. 0 cent = durağan, ±50 cent = hızlı kayma.
      final speed = widget.cents * 0.15; // piksel/frame
      _offset += speed;
      // Sonsuz döngü için mod
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
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: _StrobePainter(
            offset: _offset,
            isActive: widget.isActive,
            isInTune: widget.cents.abs() <= 3.0,
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
    // Arka plan
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.background,
    );

    if (!isActive) {
      // İnaktif: soluk çizgiler
      _drawBands(canvas, size, 0, AppColors.textMuted.withValues(alpha: 0.15));
      return;
    }

    final color = isInTune
        ? AppColors.inTune
        : AppColors.textPrimary.withValues(alpha: 0.7);

    _drawBands(canvas, size, offset, color);

    // Orta referans çizgisi
    final centerPaint = Paint()
      ..color = AppColors.inTune.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      centerPaint,
    );
  }

  void _drawBands(Canvas canvas, Size size, double off, Color color) {
    final bandWidth = 20.0;
    final gapWidth = 20.0;
    final totalWidth = bandWidth + gapWidth;
    final paint = Paint()..color = color;

    // 4 yatay sıra
    const rows = 4;
    final rowHeight = size.height / rows;

    for (int row = 0; row < rows; row++) {
      // Her sıra farklı hızda kayar (derinlik hissi)
      final rowOffset = off * (1.0 + row * 0.3);
      final y = row * rowHeight;

      for (double x = -totalWidth + (rowOffset % totalWidth);
          x < size.width + totalWidth;
          x += totalWidth) {
        canvas.drawRect(
          Rect.fromLTWH(x, y + 2, bandWidth, rowHeight - 4),
          paint,
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
