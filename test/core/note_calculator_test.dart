import 'package:flutter_test/flutter_test.dart';
import 'package:nagme/core/note_calculator.dart';
import 'package:nagme/config/instruments.dart';

void main() {
  group('NoteCalculator.noteFromFrequency', () {
    test('440 Hz → A4, 0 cents', () {
      final note = NoteCalculator.noteFromFrequency(440.0);
      expect(note!.name, 'A');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(0.5));
    });

    test('445 Hz → A4, ~+19.6 cents', () {
      final note = NoteCalculator.noteFromFrequency(445.0);
      expect(note!.name, 'A');
      expect(note.octave, 4);
      expect(note.cents, greaterThan(18.0));
      expect(note.cents, lessThan(21.0));
    });

    test('430 Hz → A4, negatif cents', () {
      final note = NoteCalculator.noteFromFrequency(430.0);
      expect(note!.name, 'A');
      expect(note.octave, 4);
      expect(note.cents, lessThan(-30.0));
    });

    test('329.6 Hz → E4, ~0 cents', () {
      final note = NoteCalculator.noteFromFrequency(329.6);
      expect(note!.name, 'E');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(5.0));
    });

    test('82.4 Hz → E2, ~0 cents (bas gitar kalın tel)', () {
      final note = NoteCalculator.noteFromFrequency(82.4);
      expect(note!.name, 'E');
      expect(note.octave, 2);
      expect(note.cents.abs(), lessThan(5.0));
    });

    test('27.5 Hz → A0 (en düşük sınır)', () {
      final note = NoteCalculator.noteFromFrequency(27.5);
      expect(note!.name, 'A');
      expect(note.octave, 0);
    });

    test('4186 Hz → C8 (en yüksek sınır)', () {
      final note = NoteCalculator.noteFromFrequency(4186.0);
      expect(note!.name, 'C');
      expect(note.octave, 8);
    });

    test('refA4=432 ile 432 Hz → A4, 0 cents', () {
      final note = NoteCalculator.noteFromFrequency(432.0, refA4: 432.0);
      expect(note!.name, 'A');
      expect(note.octave, 4);
      expect(note.cents.abs(), lessThan(0.5));
    });

    test('geçersiz frekans (0) → null', () {
      expect(NoteCalculator.noteFromFrequency(0), isNull);
      expect(NoteCalculator.noteFromFrequency(-10), isNull);
    });
  });

  group('NoteCalculator.centsOffset', () {
    test('aynı frekans → 0 cent', () {
      expect(NoteCalculator.centsOffset(440.0, 440.0), closeTo(0.0, 0.01));
    });

    test('bir oktav yukarı → +1200 cent', () {
      expect(NoteCalculator.centsOffset(880.0, 440.0), closeTo(1200.0, 1.0));
    });
  });

  group('NoteCalculator.nearestString', () {
    final violin = kInstruments.firstWhere((i) => i.id == 'violin');

    test('440 Hz → A4 teli (keman)', () {
      final string = NoteCalculator.nearestString(440.0, violin);
      expect(string!.name, 'A4');
    });

    test('300 Hz → D4 teli (keman)', () {
      final string = NoteCalculator.nearestString(300.0, violin);
      expect(string!.name, 'D4');
    });

    test('442 Hz → A4 teli (keman, hafif tiz)', () {
      final string = NoteCalculator.nearestString(442.0, violin);
      expect(string!.name, 'A4');
    });

    test('kromatik mod → null döner', () {
      final chromatic = kInstruments.firstWhere((i) => i.id == 'chromatic');
      expect(NoteCalculator.nearestString(440.0, chromatic), isNull);
    });
  });
}
