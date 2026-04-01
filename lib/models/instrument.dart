enum InstrumentCategory { strings, fretted }

class Instrument {
  final String id;
  final String name;
  final String iconAsset;
  final InstrumentCategory category;
  final List<StringTuning> strings;

  const Instrument({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.category,
    required this.strings,
  });
}

class StringTuning {
  final String name;
  final double frequency;
  final int octave;

  const StringTuning({
    required this.name,
    required this.frequency,
    required this.octave,
  });
}

// Standart akortlar
abstract final class Instruments {
  static const chromatic = Instrument(
    id: 'chromatic',
    name: 'Kromatik',
    iconAsset: 'assets/icons/waveform.svg',
    category: InstrumentCategory.fretted,
    strings: [],
  );

  static const guitar = Instrument(
    id: 'guitar',
    name: 'Gitar',
    iconAsset: 'assets/icons/guitar.svg',
    category: InstrumentCategory.fretted,
    strings: [
      StringTuning(name: 'E2', frequency: 82.41, octave: 2),
      StringTuning(name: 'A2', frequency: 110.00, octave: 2),
      StringTuning(name: 'D3', frequency: 146.83, octave: 3),
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'B3', frequency: 246.94, octave: 3),
      StringTuning(name: 'E4', frequency: 329.63, octave: 4),
    ],
  );

  static const violin = Instrument(
    id: 'violin',
    name: 'Keman',
    iconAsset: 'assets/icons/violin.svg',
    category: InstrumentCategory.strings,
    strings: [
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'D4', frequency: 293.66, octave: 4),
      StringTuning(name: 'A4', frequency: 440.00, octave: 4),
      StringTuning(name: 'E5', frequency: 659.26, octave: 5),
    ],
  );

  static const viola = Instrument(
    id: 'viola',
    name: 'Viyola',
    iconAsset: 'assets/icons/viola.svg',
    category: InstrumentCategory.strings,
    strings: [
      StringTuning(name: 'C3', frequency: 130.81, octave: 3),
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'D4', frequency: 293.66, octave: 4),
      StringTuning(name: 'A4', frequency: 440.00, octave: 4),
    ],
  );

  static const cello = Instrument(
    id: 'cello',
    name: 'Çello',
    iconAsset: 'assets/icons/cello.svg',
    category: InstrumentCategory.strings,
    strings: [
      StringTuning(name: 'C2', frequency: 65.41, octave: 2),
      StringTuning(name: 'G2', frequency: 98.00, octave: 2),
      StringTuning(name: 'D3', frequency: 146.83, octave: 3),
      StringTuning(name: 'A3', frequency: 220.00, octave: 3),
    ],
  );

  static const bass = Instrument(
    id: 'bass',
    name: 'Bas Gitar',
    iconAsset: 'assets/icons/bass.svg',
    category: InstrumentCategory.fretted,
    strings: [
      StringTuning(name: 'E1', frequency: 41.20, octave: 1),
      StringTuning(name: 'A1', frequency: 55.00, octave: 1),
      StringTuning(name: 'D2', frequency: 73.42, octave: 2),
      StringTuning(name: 'G2', frequency: 98.00, octave: 2),
    ],
  );

  static const ukulele = Instrument(
    id: 'ukulele',
    name: 'Ukulele',
    iconAsset: 'assets/icons/ukulele.svg',
    category: InstrumentCategory.fretted,
    strings: [
      StringTuning(name: 'G4', frequency: 392.00, octave: 4),
      StringTuning(name: 'C4', frequency: 261.63, octave: 4),
      StringTuning(name: 'E4', frequency: 329.63, octave: 4),
      StringTuning(name: 'A4', frequency: 440.00, octave: 4),
    ],
  );

  static const baglama = Instrument(
    id: 'baglama',
    name: 'Bağlama',
    iconAsset: 'assets/icons/baglama.svg',
    category: InstrumentCategory.fretted,
    strings: [
      // Üst grup (2 tel)
      StringTuning(name: 'A3', frequency: 220.00, octave: 3),
      StringTuning(name: 'A3', frequency: 220.00, octave: 3),
      // Orta grup (2 tel)
      StringTuning(name: 'D3', frequency: 146.83, octave: 3),
      StringTuning(name: 'D4', frequency: 293.66, octave: 4),
      // Alt grup (3 tel)
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'G4', frequency: 392.00, octave: 4),
    ],
  );

  static const ud = Instrument(
    id: 'ud',
    name: 'Ud',
    iconAsset: 'assets/icons/ud.svg',
    category: InstrumentCategory.fretted,
    strings: [
      // Kurs 1 (tek tel)
      StringTuning(name: 'C2', frequency: 65.41, octave: 2),
      // Kurs 2 (çift tel)
      StringTuning(name: 'D2', frequency: 73.42, octave: 2),
      StringTuning(name: 'D2', frequency: 73.42, octave: 2),
      // Kurs 3 (çift tel)
      StringTuning(name: 'G2', frequency: 98.00, octave: 2),
      StringTuning(name: 'G2', frequency: 98.00, octave: 2),
      // Kurs 4 (çift tel)
      StringTuning(name: 'A2', frequency: 110.00, octave: 2),
      StringTuning(name: 'A2', frequency: 110.00, octave: 2),
      // Kurs 5 (çift tel)
      StringTuning(name: 'D3', frequency: 146.83, octave: 3),
      StringTuning(name: 'D3', frequency: 146.83, octave: 3),
      // Kurs 6 (çift tel)
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
      StringTuning(name: 'G3', frequency: 196.00, octave: 3),
    ],
  );

  static const all = [
    chromatic, violin, guitar, bass, ukulele, baglama, ud, viola, cello,
  ];
}
