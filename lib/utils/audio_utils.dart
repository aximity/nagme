import 'dart:math';
import 'dart:typed_data';

/// Sentetik sinüs dalgası üretir (test için).
Float32List generateSineWave({
  required double frequency,
  int sampleRate = 44100,
  int length = 4096,
  double amplitude = 0.5,
}) {
  final buffer = Float32List(length);
  for (int i = 0; i < length; i++) {
    buffer[i] = (amplitude * sin(2.0 * pi * frequency * i / sampleRate))
        .toDouble();
  }
  return buffer;
}

/// Sessiz buffer üretir (test için).
Float32List generateSilence({int length = 4096}) {
  return Float32List(length);
}
