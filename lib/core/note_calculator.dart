import 'dart:math';
import 'package:nagme/models/note.dart';
import 'package:nagme/models/instrument.dart';

/// 12-TET nota isimleri (C=0 ... B=11)
const List<String> _noteNames = [
  'C', 'C#', 'D', 'D#', 'E', 'F',
  'F#', 'G', 'G#', 'A', 'A#', 'B',
];

/// Frekansı en yakın notaya dönüştürür.
///
/// [frequency]: algılanan frekans (Hz)
/// [refA4]: referans A4 frekansı (varsayılan 440 Hz)
///
/// Döndürür: Note (isim, oktav, cent sapma)
Note noteFromFrequency(double frequency, {double refA4 = 440.0}) {
  // A4 = MIDI 69. Yarım ton farkı hesapla.
  final double semitonesFromA4 = 12.0 * _log2(frequency / refA4);
  final int nearestSemitone = semitonesFromA4.round();
  final double cents = (semitonesFromA4 - nearestSemitone) * 100.0;

  // MIDI nota numarası: A4 = 69
  final int midiNote = 69 + nearestSemitone;

  // Nota adı ve oktav
  final int noteIndex = midiNote % 12;
  final int octave = (midiNote ~/ 12) - 1;

  return Note(
    name: _noteNames[noteIndex],
    octave: octave,
    frequency: frequency,
    cents: cents,
  );
}

/// Verilen frekansa en yakın enstrüman telini bulur.
///
/// Kromatik modda (strings boş) null döner.
StringTuning? nearestString(double frequency, InstrumentTuning instrument) {
  if (instrument.isChromatic || instrument.strings.isEmpty) return null;

  StringTuning? closest;
  double minDistance = double.infinity;

  for (final s in instrument.strings) {
    // Cent cinsinden mesafe (mutlak)
    final double distance = (1200.0 * _log2(frequency / s.frequency)).abs();
    if (distance < minDistance) {
      minDistance = distance;
      closest = s;
    }
  }

  return closest;
}

/// Verilen frekansın referans frekansa göre cent sapmasını hesaplar.
double centsFromTarget(double frequency, double targetFrequency) {
  return 1200.0 * _log2(frequency / targetFrequency);
}

/// MIDI nota numarasını frekansa dönüştürür.
double frequencyFromMidi(int midiNote, {double refA4 = 440.0}) {
  return refA4 * pow(2.0, (midiNote - 69) / 12.0);
}

double _log2(double x) => log(x) / ln2;
