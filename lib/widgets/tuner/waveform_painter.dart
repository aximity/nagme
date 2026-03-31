import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagme/config/theme.dart';
import 'package:nagme/providers/tuner_provider.dart';

/// Canlı audio buffer'ı dalga formu olarak çizen widget.
/// RepaintBoundary ile sarılır — sadece waveform yeniden çizilir.
class WaveformWidget extends ConsumerStatefulWidget {
  const WaveformWidget({super.key, required this.isActive});

  final bool isActive;

  @override
  ConsumerState<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends ConsumerState<WaveformWidget> {
  Float32List? _buffer;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    final audioService = ref.read(audioServiceProvider);
    audioService.bufferStream.listen((buf) {
      if (mounted && widget.isActive) {
        setState(() => _buffer = buf);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.isActive ? 0.6 : 0.15,
        child: SizedBox(
          height: 48,
          child: CustomPaint(
            painter: _WaveformPainter(
              buffer: _buffer,
              isActive: widget.isActive,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({required this.buffer, required this.isActive});

  final Float32List? buffer;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    final buf = buffer;
    if (buf == null || buf.isEmpty) {
      _drawIdle(canvas, size);
      return;
    }

    final paint = Paint()
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Aktifken amber gradient, pasifken düz renk
    if (isActive) {
      paint.shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryContainer, AppColors.primary],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      paint.color = AppColors.primaryContainer;
    }

    final path = Path();
    final step = size.width / buf.length;
    final mid = size.height / 2;
    final amp = size.height * 0.45;

    path.moveTo(0, mid + buf[0].clamp(-1.0, 1.0) * amp);
    for (int i = 1; i < buf.length; i++) {
      path.lineTo(i * step, mid + buf[i].clamp(-1.0, 1.0) * amp);
    }

    canvas.drawPath(path, paint);
  }

  /// Sessizlik için statik sinüs benzeri çizgi
  void _drawIdle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryContainer
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    const steps = 120;
    path.moveTo(0, size.height / 2);
    for (int i = 1; i <= steps; i++) {
      final x = size.width * i / steps;
      final phase = i / steps * 3.14159 * 6;
      final y = size.height / 2 + (size.height * 0.15) * (i % 20 < 10 ? 0.3 : -0.3);
      path.lineTo(x, y + (size.height * 0.05) * (phase % 2 < 1 ? 1 : -1));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.buffer != buffer || old.isActive != isActive;
}
