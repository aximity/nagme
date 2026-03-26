import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/pitch_detector.dart';
import 'package:nagme/utils/audio_utils.dart';

void main() {
  const detector = PitchDetector();

  group('PitchDetector - YIN', () {
    test('440Hz sinüs → ~440Hz algılar', () {
      final buffer = generateSineWave(frequency: 440.0);
      final result = detector.detect(buffer);
      expect(result, closeTo(440.0, 3.0));
    });

    test('880Hz sinüs → ~880Hz algılar', () {
      final buffer = generateSineWave(frequency: 880.0);
      final result = detector.detect(buffer);
      expect(result, closeTo(880.0, 5.0));
    });

    test('220Hz sinüs → ~220Hz algılar', () {
      final buffer = generateSineWave(frequency: 220.0);
      final result = detector.detect(buffer);
      expect(result, closeTo(220.0, 2.0));
    });

    test('330Hz sinüs → ~330Hz algılar', () {
      final buffer = generateSineWave(frequency: 329.63);
      final result = detector.detect(buffer);
      expect(result, closeTo(329.63, 3.0));
    });

    test('110Hz sinüs → ~110Hz algılar', () {
      final buffer = generateSineWave(frequency: 110.0, length: 8192);
      final detectorLarge = PitchDetector();
      final result = detectorLarge.detect(buffer);
      expect(result, closeTo(110.0, 2.0));
    });

    test('sessizlik → -1 döner', () {
      final buffer = generateSilence();
      final result = detector.detect(buffer);
      expect(result, -1.0);
    });

    test('RMS hesaplaması doğru', () {
      final buffer = generateSineWave(frequency: 440.0, amplitude: 0.5);
      final rmsValue = PitchDetector.rms(buffer);
      // Sinüs dalgasının RMS'i = amplitude / sqrt(2) ≈ 0.354
      expect(rmsValue, closeTo(0.354, 0.02));
    });
  });
}
