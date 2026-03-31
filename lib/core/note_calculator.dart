import 'dart:math';
import 'package:nagme/models/instrument.dart';
import 'package:nagme/models/note.dart';
import 'package:nagme/utils/note_utils.dart';

class NoteCalculator {
  NoteCalculator._();

  /// Frekans (Hz) → Note dönüşümü.
  /// [refA4] referans la frekansı (varsayılan 440 Hz).
  static Note? noteFromFrequency(double freq, {double refA4 = 440.0}) {
    if (freq <= 0) return null;

    // A4 = MIDI 69. Semitone sayısı = 12 * log2(freq / refA4)
    final semitones = kNotesPerOctave * log(freq / refA4) / ln2;
    final midiNumber = kA4MidiNumber + semitones;
    final roundedMidi = midiNumber.round();

    // Oktav ve nota indeksi
    final octave = (roundedMidi ~/ kNotesPerOctave) - 1;
    final noteIndex = roundedMidi % kNotesPerOctave;
    final noteName = kNoteNames[noteIndex];

    // Cent farkı: gerçek MIDI – yuvarlanan MIDI
    final cents = (midiNumber - roundedMidi) * 100.0;

    return Note(
      name: noteName,
      octave: octave,
      frequency: freq,
      cents: cents,
    );
  }

  /// İki frekans arasındaki cent farkını hesaplar.
  static double centsOffset(double measuredFreq, double targetFreq) {
    if (targetFreq <= 0 || measuredFreq <= 0) return 0.0;
    return kNotesPerOctave * 100.0 * log(measuredFreq / targetFreq) / ln2;
  }

  /// Enstrümanda en yakın teli bulur.
  static StringTuning? nearestString(
    double freq,
    InstrumentTuning instrument,
  ) {
    if (instrument.isChromatic || freq <= 0) return null;

    StringTuning? nearest;
    double minDist = double.infinity;

    for (final string in instrument.strings) {
      final dist = (centsOffset(freq, string.frequency)).abs();
      if (dist < minDist) {
        minDist = dist;
        nearest = string;
      }
    }

    return nearest;
  }
}
