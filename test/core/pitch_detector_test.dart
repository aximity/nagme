import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/pitch_detector.dart';
import 'package:nagme/utils/audio_utils.dart';
import 'package:nagme/config/constants.dart';

void main() {
  const sampleRate = AppConstants.sampleRate;
  const bufferSize = AppConstants.bufferSize;

  group('detectPitch', () {
    test('440 Hz sinüs → ~440 Hz', () {
      final buffer = generateSineWave(440.0, sampleRate, bufferSize);
      final result = detectPitch(PitchInput(buffer, sampleRate));
      expect(result, greaterThan(0));
      expect(result, closeTo(440.0, 5.0)); // ±5 Hz tolerans
    });

    test('220 Hz sinüs → ~220 Hz', () {
      final buffer = generateSineWave(220.0, sampleRate, bufferSize);
      final result = detectPitch(PitchInput(buffer, sampleRate));
      expect(result, greaterThan(0));
      expect(result, closeTo(220.0, 5.0));
    });

    test('880 Hz sinüs → ~880 Hz', () {
      final buffer = generateSineWave(880.0, sampleRate, bufferSize);
      final result = detectPitch(PitchInput(buffer, sampleRate));
      expect(result, greaterThan(0));
      expect(result, closeTo(880.0, 10.0));
    });

    test('sıfır buffer (sessizlik) → -1.0', () {
      final buffer = generateSineWave(0, sampleRate, bufferSize);
      final result = detectPitch(PitchInput(buffer, sampleRate));
      expect(result, equals(-1.0));
    });

    test('çok düşük genlikli sinyal → -1.0 (gürültü gate)', () {
      final buffer = generateSineWave(440.0, sampleRate, bufferSize);
      // Genliliği RMS eşiğinin altına düşür
      for (int i = 0; i < buffer.length; i++) {
        buffer[i] = buffer[i] * 0.0001;
      }
      final result = detectPitch(PitchInput(buffer, sampleRate));
      expect(result, equals(-1.0));
    });
  });
}
