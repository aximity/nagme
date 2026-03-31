// Bu test çalıştırılınca assets/icon/ ve assets/splash/ klasörlerine
// PNG dosyaları üretir.
//
// Kullanım:
//   flutter test test/generate_assets_test.dart

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate app_icon.png (1024x1024, dark bg)', () async {
    final bytes = await _renderIcon(size: 1024, withBackground: true);
    _save('assets/icon/app_icon.png', bytes);
    expect(bytes.lengthInBytes, greaterThan(0));
  });

  test('generate app_icon_adaptive_fg.png (1024x1024, transparent bg)', () async {
    final bytes = await _renderIcon(size: 1024, withBackground: false);
    _save('assets/icon/app_icon_adaptive_fg.png', bytes);
    expect(bytes.lengthInBytes, greaterThan(0));
  });

  test('generate splash_logo.png (512x512, transparent bg)', () async {
    final bytes = await _renderIcon(size: 512, withBackground: false);
    _save('assets/splash/splash_logo.png', bytes);
    expect(bytes.lengthInBytes, greaterThan(0));
  });
}

// ─────────────────────────────────────────────
// Render
// ─────────────────────────────────────────────

Future<ByteData> _renderIcon({
  required int size,
  required bool withBackground,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(
    recorder,
    ui.Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
  );

  _drawIcon(canvas, size.toDouble(), withBackground: withBackground);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!;
}

// ─────────────────────────────────────────────
// Icon painter — Stitch tasarımı birebir
// SVG kaynak: M20,100 A80,80 0 0,1 180,100  (200x120 viewBox)
// ─────────────────────────────────────────────

void _drawIcon(ui.Canvas canvas, double s, {required bool withBackground}) {
  // Renkler (Stitch token'larından)
  const bgColor      = ui.Color(0xFF111125);
  const trackColor   = ui.Color(0xFF333348);
  const amberColor   = ui.Color(0xFFF4A261);
  const needleColor  = ui.Color(0xFFFFC499);

  if (withBackground) {
    // Arka plan — tam kare (rounded köşeyi OS uygular)
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, s, s),
      ui.Paint()..color = bgColor,
    );
  }

  // ── Gauge koordinatları ──
  // Merkez Y biraz aşağıda, görsel ağırlık dengesi için
  final cx = s / 2;
  final cy = s * 0.58;
  final r  = s * 0.32;       // yay yarıçapı

  final arcRect = ui.Rect.fromCircle(
    center: ui.Offset(cx, cy),
    radius: r,
  );

  final strokeW = s * 0.028;

  // Arka plan yayı (track)
  canvas.drawArc(
    arcRect,
    pi, pi, false,
    ui.Paint()
      ..color = trackColor
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = ui.StrokeCap.round,
  );

  // Amber glow katmanı
  canvas.drawArc(
    arcRect,
    pi, pi, false,
    ui.Paint()
      ..color = const ui.Color(0x47F4A261)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = strokeW * 2.2
      ..strokeCap = ui.StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 18),
  );

  // Amber yay (solid)
  canvas.drawArc(
    arcRect,
    pi, pi, false,
    ui.Paint()
      ..color = amberColor
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = ui.StrokeCap.round,
  );

  // ── İbre (needle) — tam yukarı ──
  final needleBase = ui.Offset(cx, cy);
  final needleTop  = ui.Offset(cx, cy - r);

  // İbre glow
  canvas.drawLine(
    needleBase,
    needleTop,
    ui.Paint()
      ..color = const ui.Color(0x4DFFC499)
      ..strokeWidth = strokeW * 1.6
      ..strokeCap = ui.StrokeCap.round
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 12),
  );

  // İbre solid
  canvas.drawLine(
    needleBase,
    needleTop,
    ui.Paint()
      ..color = needleColor
      ..strokeWidth = strokeW * 0.72
      ..strokeCap = ui.StrokeCap.round,
  );

  // Merkez pivot dairesi
  canvas.drawCircle(
    needleBase,
    strokeW * 0.9,
    ui.Paint()..color = trackColor,
  );
  canvas.drawCircle(
    needleBase,
    strokeW * 0.6,
    ui.Paint()..color = needleColor,
  );

  // Üst nokta (in-tune indicator dot)
  canvas.drawCircle(
    needleTop,
    strokeW * 0.7,
    ui.Paint()
      ..color = const ui.Color(0x59FFC499)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8),
  );
  canvas.drawCircle(
    needleTop,
    strokeW * 0.55,
    ui.Paint()..color = needleColor,
  );

  // ── Waveform bars (7 çubuk, yay altında) ──
  const barRatios = [0.35, 0.65, 0.50, 1.0, 0.50, 0.65, 0.35];
  final maxBarH   = s * 0.055;
  final barW      = s * 0.012;
  final barGap    = s * 0.022;
  final totalW    = barRatios.length * barW + (barRatios.length - 1) * barGap;
  final barsLeft  = cx - totalW / 2;
  final barsY     = cy + r * 0.20;

  final barPaint = ui.Paint()
    ..color = const ui.Color(0x33FFC499)
    ..style = ui.PaintingStyle.fill;

  for (int i = 0; i < barRatios.length; i++) {
    final bh  = maxBarH * barRatios[i];
    final bx  = barsLeft + i * (barW + barGap);
    final rrect = ui.RRect.fromRectAndRadius(
      ui.Rect.fromLTWH(bx, barsY - bh / 2, barW, bh),
      const ui.Radius.circular(3),
    );
    canvas.drawRRect(rrect, barPaint);
  }
}

// ─────────────────────────────────────────────
// Yardımcı
// ─────────────────────────────────────────────

void _save(String path, ByteData bytes) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes.buffer.asUint8List());
}
