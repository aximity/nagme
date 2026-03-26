import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/config/instruments.dart';

void main() {
  group('InstrumentTuning', () {
    test('keman 4 telli', () {
      final violin = defaultInstruments.firstWhere((i) => i.id == 'violin');
      expect(violin.stringCount, 4);
      expect(violin.isChromatic, false);
      expect(violin.strings.map((s) => s.name).toList(),
          ['G', 'D', 'A', 'E']);
    });

    test('gitar 6 telli', () {
      final guitar = defaultInstruments.firstWhere((i) => i.id == 'guitar');
      expect(guitar.stringCount, 6);
    });

    test('kromatik mod boş telli', () {
      expect(chromaticMode.isChromatic, true);
      expect(chromaticMode.stringCount, 0);
    });

    test('tüm enstrümanlar benzersiz id ye sahip', () {
      final ids = defaultInstruments.map((i) => i.id).toSet();
      expect(ids.length, defaultInstruments.length);
    });

    test('tüm enstrümanlarda teller pozitif frekanslı', () {
      for (final inst in defaultInstruments) {
        for (final s in inst.strings) {
          expect(s.frequency, greaterThan(0.0),
              reason: '${inst.name} - ${s.name} frekansı > 0 olmalı');
        }
      }
    });
  });

  group('StringTuning', () {
    test('fullName doğru üretilir', () {
      const s = StringTuning(name: 'A', octave: 4, frequency: 440.0);
      expect(s.fullName, 'A4');
    });
  });
}
