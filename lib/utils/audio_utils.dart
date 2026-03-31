import 'dart:math';
import 'dart:typed_data';

double calculateRms(Float32List buffer) {
  if (buffer.isEmpty) return 0.0;
  double sum = 0.0;
  for (final sample in buffer) {
    sum += sample * sample;
  }
  return sqrt(sum / buffer.length);
}

/// Test amaçlı sentetik sinüs dalgası üretir.
Float32List generateSineWave(double frequency, int sampleRate, int length) {
  final buffer = Float32List(length);
  for (int i = 0; i < length; i++) {
    buffer[i] = sin(2 * pi * frequency * i / sampleRate);
  }
  return buffer;
}
