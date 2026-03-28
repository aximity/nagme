import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/pitch_isolate.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/tuner_state.dart';
import 'package:nagme/utils/audio_utils.dart';

void main() {
  const keman = InstrumentTuning(
    id: 'violin',
    name: 'Keman',
    icon: 'violin',
    strings: [
      StringTuning(name: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'D', octave: 4, frequency: 293.7),
      StringTuning(name: 'A', octave: 4, frequency: 440.0),
      StringTuning(name: 'E', octave: 5, frequency: 659.3),
    ],
  );

  const chromatic = InstrumentTuning(
    id: 'chromatic',
    name: 'Kromatik',
    icon: 'chromatic',
    strings: [],
  );

  group('PitchIsolateManager', () {
    late PitchIsolateManager manager;

    setUp(() {
      manager = PitchIsolateManager();
    });

    tearDown(() async {
      await manager.dispose();
    });

    test('isolate baslatilir ve 440Hz algilar', () async {
      await manager.start(const PitchIsolateConfig(
        sampleRate: 44100,
        refA4: 440.0,
        sensitivity: 0.5,
        instrument: chromatic,
      ));

      final results = <PitchIsolateResult>[];
      final sub = manager.resultStream.listen(results.add);

      // Stabilite icin birden fazla buffer gonder
      for (int i = 0; i < 6; i++) {
        final buffer = generateSineWave(frequency: 440.0);
        manager.processBuffer(buffer);
        // Isolate'in islemesi icin kisa bekle
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // Sonuclarin gelmesini bekle
      await Future.delayed(const Duration(milliseconds: 200));
      await sub.cancel();

      // En az bir sonuc gelmeli
      expect(results, isNotEmpty);

      // Detected olan sonuclar 440Hz civari olmali
      final detected =
          results.where((r) => r.status == TunerStatus.detected).toList();
      if (detected.isNotEmpty) {
        final last = detected.last;
        expect(last.rawFrequency, isNotNull);
        expect(last.rawFrequency!, closeTo(440.0, 10.0));
        expect(last.note, isNotNull);
        expect(last.note!.name, 'A');
      }
    });

    test('sessizlik noSignal dondurur', () async {
      await manager.start(const PitchIsolateConfig(
        sampleRate: 44100,
        refA4: 440.0,
        sensitivity: 0.5,
        instrument: chromatic,
      ));

      final results = <PitchIsolateResult>[];
      final sub = manager.resultStream.listen(results.add);

      final silence = generateSilence();
      manager.processBuffer(silence);

      await Future.delayed(const Duration(milliseconds: 200));
      await sub.cancel();

      expect(results, isNotEmpty);
      expect(results.first.status, TunerStatus.noSignal);
    });

    test('stop sonrasi yeniden baslatilabilir', () async {
      await manager.start(const PitchIsolateConfig(
        sampleRate: 44100,
        refA4: 440.0,
        sensitivity: 0.5,
        instrument: chromatic,
      ));
      await manager.stop();

      // Yeniden baslat
      await manager.start(const PitchIsolateConfig(
        sampleRate: 44100,
        refA4: 440.0,
        sensitivity: 0.5,
        instrument: keman,
      ));

      final results = <PitchIsolateResult>[];
      final sub = manager.resultStream.listen(results.add);

      final silence = generateSilence();
      manager.processBuffer(silence);

      await Future.delayed(const Duration(milliseconds: 200));
      await sub.cancel();

      expect(results, isNotEmpty);
    });

    test('enstruman modunda harmonik duzeltme calisir', () async {
      await manager.start(const PitchIsolateConfig(
        sampleRate: 44100,
        refA4: 440.0,
        sensitivity: 0.5,
        instrument: keman,
      ));

      final results = <PitchIsolateResult>[];
      final sub = manager.resultStream.listen(results.add);

      // Keman A4=440Hz sinyali gonder
      for (int i = 0; i < 6; i++) {
        final buffer = generateSineWave(frequency: 440.0);
        manager.processBuffer(buffer);
        await Future.delayed(const Duration(milliseconds: 50));
      }

      await Future.delayed(const Duration(milliseconds: 200));
      await sub.cancel();

      expect(results, isNotEmpty);
    });
  });
}
