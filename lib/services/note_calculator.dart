import 'dart:math';

class NoteInfo {
  final String name;
  final int octave;
  final double cents;
  final double expectedFrequency;

  const NoteInfo({
    required this.name,
    required this.octave,
    required this.cents,
    required this.expectedFrequency,
  });
}

class NoteCalculator {
  static const List<String> _noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  /// A4'ün MIDI numarası = 69
  static const int _a4Midi = 69;

  /// Frekansı en yakın notaya çevirir.
  /// [referenceA4]: A4 referans frekansı (varsayılan 440 Hz)
  static NoteInfo fromFrequency(double frequency, {double referenceA4 = 440.0}) {
    if (frequency <= 0) {
      return const NoteInfo(name: '--', octave: 0, cents: 0, expectedFrequency: 0);
    }

    // Frekans → MIDI nota numarası (kesirli)
    final double midiNote = 12 * (log(frequency / referenceA4) / ln2) + _a4Midi;

    // En yakın tam MIDI nota numarası
    final int nearestMidi = midiNote.round();

    // Cent sapması: gerçek - en yakın
    final double cents = (midiNote - nearestMidi) * 100;

    // Nota adı ve oktav
    final int noteIndex = nearestMidi % 12;
    final int octave = (nearestMidi ~/ 12) - 1;

    // En yakın notanın beklenen frekansı
    final double expectedFreq =
        referenceA4 * pow(2, (nearestMidi - _a4Midi) / 12);

    return NoteInfo(
      name: _noteNames[noteIndex],
      octave: octave,
      cents: cents.clamp(-50.0, 50.0),
      expectedFrequency: expectedFreq,
    );
  }
}
