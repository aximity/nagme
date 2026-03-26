import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/note_calculator.dart';
import 'package:nagme/config/instruments.dart';

void main() {
  group('noteFromFrequency', () {
    test('A4=440Hz → A4, 0 cents', () {
      final note = noteFromFrequency(440.0);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(0.1));
    });

    test('442Hz → A4, ~+7.9 cents', () {
      final note = noteFromFrequency(442.0);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.cents, closeTo(7.85, 0.5));
    });

    test('329.6Hz → E4, ~0 cents', () {
      final note = noteFromFrequency(329.63);
      expect(note.name, 'E');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(1.0));
    });

    test('82.4Hz → E2, ~0 cents (bas gitar en kalın tel)', () {
      final note = noteFromFrequency(82.41);
      expect(note.name, 'E');
      expect(note.octave, 2);
      expect(note.cents.abs(), lessThan(1.0));
    });

    test('27.5Hz → A0 (en düşük sınır)', () {
      final note = noteFromFrequency(27.5);
      expect(note.name, 'A');
      expect(note.octave, 0);
      expect(note.cents.abs(), lessThan(0.1));
    });

    test('4186Hz → C8 (en yüksek sınır)', () {
      final note = noteFromFrequency(4186.01);
      expect(note.name, 'C');
      expect(note.octave, 8);
      expect(note.cents.abs(), lessThan(1.0));
    });

    test('refA4=432 ile 432Hz → A4, 0 cents', () {
      final note = noteFromFrequency(432.0, refA4: 432.0);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(0.1));
    });

    test('445Hz → A4, +19.6 cents', () {
      final note = noteFromFrequency(445.0);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.cents, closeTo(19.56, 0.5));
    });

    test('430Hz → A4, ~-40 cents', () {
      final note = noteFromFrequency(430.0);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.cents, closeTo(-39.9, 1.0));
    });

    test('C4 = 261.63Hz', () {
      final note = noteFromFrequency(261.63);
      expect(note.name, 'C');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(1.0));
    });
  });

  group('nearestString', () {
    test('keman + 300Hz → D4 teli', () {
      final violin = defaultInstruments.firstWhere((i) => i.id == 'violin');
      final result = nearestString(300.0, violin);
      expect(result, isNotNull);
      expect(result!.name, 'D');
      expect(result.octave, 4);
    });

    test('keman + 440Hz → A4 teli', () {
      final violin = defaultInstruments.firstWhere((i) => i.id == 'violin');
      final result = nearestString(440.0, violin);
      expect(result, isNotNull);
      expect(result!.name, 'A');
      expect(result.octave, 4);
    });

    test('gitar + 82Hz → E2 teli', () {
      final guitar = defaultInstruments.firstWhere((i) => i.id == 'guitar');
      final result = nearestString(82.0, guitar);
      expect(result, isNotNull);
      expect(result!.name, 'E');
      expect(result.octave, 2);
    });

    test('kromatik modda null döner', () {
      final result = nearestString(440.0, chromaticMode);
      expect(result, isNull);
    });
  });

  group('centsFromTarget', () {
    test('aynı frekans → 0 cent', () {
      expect(centsFromTarget(440.0, 440.0), closeTo(0.0, 0.01));
    });

    test('bir oktav yukarı → 1200 cent', () {
      expect(centsFromTarget(880.0, 440.0), closeTo(1200.0, 0.01));
    });

    test('yarım ton yukarı → ~100 cent', () {
      expect(centsFromTarget(466.16, 440.0), closeTo(100.0, 1.0));
    });
  });
}
