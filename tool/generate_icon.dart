// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';

/// Nağme app ikonu üretici — koyu arka plan, amber diyapazon.
void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  // Arka plan: #0D0D0D
  img.fill(image, color: img.ColorRgba8(13, 13, 13, 255));

  // Daire arka plan (hafif gradient hissi)
  _drawFilledCircle(image, size ~/ 2, size ~/ 2, 420, img.ColorRgba8(26, 26, 26, 255));

  // Diyapazon çiz (amber #FFB300)
  final amber = img.ColorRgba8(255, 179, 0, 255);
  final amberLight = img.ColorRgba8(255, 204, 51, 255);

  // Sol çatal
  _drawThickLine(image, 430, 200, 430, 520, 28, amber);
  // Sag çatal
  _drawThickLine(image, 594, 200, 594, 520, 28, amber);
  // Ust kavis (sol)
  _drawThickLine(image, 430, 200, 480, 160, 28, amber);
  // Ust kavis (sag)
  _drawThickLine(image, 594, 200, 544, 160, 28, amber);
  // Ust kavis (orta)
  _drawThickLine(image, 480, 160, 544, 160, 28, amberLight);
  // Sap
  _drawThickLine(image, 512, 520, 512, 820, 32, amber);
  // Taban top
  _drawFilledCircle(image, 512, 830, 30, amber);

  // Kaydet
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) iconDir.createSync(recursive: true);

  // Ana ikon (kare)
  File('assets/icon/app_icon.png').writeAsBytesSync(img.encodePng(image));

  // Foreground (adaptive icon icin — ayni)
  File('assets/icon/app_icon_foreground.png')
      .writeAsBytesSync(img.encodePng(image));

  print('App icon generated: assets/icon/app_icon.png');
}

void _drawFilledCircle(img.Image image, int cx, int cy, int radius, img.Color color) {
  for (int y = cy - radius; y <= cy + radius; y++) {
    for (int x = cx - radius; x <= cx + radius; x++) {
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        final dx = x - cx;
        final dy = y - cy;
        if (dx * dx + dy * dy <= radius * radius) {
          image.setPixel(x, y, color);
        }
      }
    }
  }
}

void _drawThickLine(img.Image image, int x1, int y1, int x2, int y2, int thickness, img.Color color) {
  final halfT = thickness ~/ 2;
  final dx = x2 - x1;
  final dy = y2 - y1;
  final steps = max(dx.abs(), dy.abs());
  if (steps == 0) return;

  for (int i = 0; i <= steps; i++) {
    final x = x1 + (dx * i / steps).round();
    final y = y1 + (dy * i / steps).round();
    for (int tx = -halfT; tx <= halfT; tx++) {
      for (int ty = -halfT; ty <= halfT; ty++) {
        final px = x + tx;
        final py = y + ty;
        if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
          if (tx * tx + ty * ty <= halfT * halfT) {
            image.setPixel(px, py, color);
          }
        }
      }
    }
  }
}
