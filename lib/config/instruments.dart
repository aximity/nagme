import 'package:nagme/models/instrument.dart';

/// Tüm desteklenen enstrümanlar ve akort tanımları
const List<InstrumentTuning> defaultInstruments = [
  InstrumentTuning(
    id: 'violin',
    name: 'Keman',
    icon: '🎻',
    strings: [
      StringTuning(name: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'D', octave: 4, frequency: 293.66),
      StringTuning(name: 'A', octave: 4, frequency: 440.0),
      StringTuning(name: 'E', octave: 5, frequency: 659.26),
    ],
  ),
  InstrumentTuning(
    id: 'guitar',
    name: 'Gitar',
    icon: '🎸',
    strings: [
      StringTuning(name: 'E', octave: 2, frequency: 82.41),
      StringTuning(name: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'D', octave: 3, frequency: 146.83),
      StringTuning(name: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'B', octave: 3, frequency: 246.94),
      StringTuning(name: 'E', octave: 4, frequency: 329.63),
    ],
  ),
  InstrumentTuning(
    id: 'bass_guitar',
    name: 'Bas Gitar',
    icon: '🎸',
    strings: [
      StringTuning(name: 'E', octave: 1, frequency: 41.20),
      StringTuning(name: 'A', octave: 1, frequency: 55.0),
      StringTuning(name: 'D', octave: 2, frequency: 73.42),
      StringTuning(name: 'G', octave: 2, frequency: 98.0),
    ],
  ),
  InstrumentTuning(
    id: 'ukulele',
    name: 'Ukulele',
    icon: '🪕',
    strings: [
      StringTuning(name: 'G', octave: 4, frequency: 392.0),
      StringTuning(name: 'C', octave: 4, frequency: 261.63),
      StringTuning(name: 'E', octave: 4, frequency: 329.63),
      StringTuning(name: 'A', octave: 4, frequency: 440.0),
    ],
  ),
  InstrumentTuning(
    id: 'baglama',
    name: 'Bağlama',
    icon: '🪕',
    strings: [
      StringTuning(name: 'La', octave: 2, frequency: 110.0),
      StringTuning(name: 'La', octave: 2, frequency: 110.0),
      StringTuning(name: 'Re', octave: 3, frequency: 146.83),
      StringTuning(name: 'Re', octave: 3, frequency: 146.83),
      StringTuning(name: 'Sol', octave: 3, frequency: 196.0),
      StringTuning(name: 'Sol', octave: 3, frequency: 196.0),
      StringTuning(name: 'Sol', octave: 4, frequency: 392.0),
    ],
  ),
  InstrumentTuning(
    id: 'ud',
    name: 'Ud',
    icon: '🪕',
    strings: [
      StringTuning(name: 'Yegah', octave: 2, frequency: 73.42),
      StringTuning(name: 'Yegah', octave: 2, frequency: 73.42),
      StringTuning(name: 'Aşiran', octave: 2, frequency: 98.0),
      StringTuning(name: 'Aşiran', octave: 2, frequency: 98.0),
      StringTuning(name: 'Rast', octave: 2, frequency: 110.0),
      StringTuning(name: 'Rast', octave: 2, frequency: 110.0),
      StringTuning(name: 'Düga', octave: 3, frequency: 146.83),
      StringTuning(name: 'Düga', octave: 3, frequency: 146.83),
      StringTuning(name: 'Neva', octave: 3, frequency: 196.0),
      StringTuning(name: 'Neva', octave: 3, frequency: 196.0),
      StringTuning(name: 'Bam', octave: 3, frequency: 130.81),
    ],
  ),
  InstrumentTuning(
    id: 'viola',
    name: 'Viyola',
    icon: '🎻',
    strings: [
      StringTuning(name: 'C', octave: 3, frequency: 130.81),
      StringTuning(name: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'D', octave: 4, frequency: 293.66),
      StringTuning(name: 'A', octave: 4, frequency: 440.0),
    ],
  ),
  InstrumentTuning(
    id: 'cello',
    name: 'Çello',
    icon: '🎻',
    strings: [
      StringTuning(name: 'C', octave: 2, frequency: 65.41),
      StringTuning(name: 'G', octave: 2, frequency: 98.0),
      StringTuning(name: 'D', octave: 3, frequency: 146.83),
      StringTuning(name: 'A', octave: 3, frequency: 220.0),
    ],
  ),
];

/// Kromatik mod — enstrümansız, tüm notaları algılar
const InstrumentTuning chromaticMode = InstrumentTuning(
  id: 'chromatic',
  name: 'Kromatik',
  icon: '🎵',
  strings: [],
);

/// Enstrümana göre alternatif akort düzenleri.
/// Key: enstrüman id, Value: alternatif tuning listesi (standart hariç).
const Map<String, List<InstrumentTuning>> alternativeTunings = {
  // --- Gitar ---
  'guitar': [
    InstrumentTuning(
      id: 'guitar',
      name: 'Gitar',
      icon: '🎸',
      tuningName: 'Drop D',
      strings: [
        StringTuning(name: 'D', octave: 2, frequency: 73.42),
        StringTuning(name: 'A', octave: 2, frequency: 110.0),
        StringTuning(name: 'D', octave: 3, frequency: 146.83),
        StringTuning(name: 'G', octave: 3, frequency: 196.0),
        StringTuning(name: 'B', octave: 3, frequency: 246.94),
        StringTuning(name: 'E', octave: 4, frequency: 329.63),
      ],
    ),
    InstrumentTuning(
      id: 'guitar',
      name: 'Gitar',
      icon: '🎸',
      tuningName: 'Open G',
      strings: [
        StringTuning(name: 'D', octave: 2, frequency: 73.42),
        StringTuning(name: 'G', octave: 2, frequency: 98.0),
        StringTuning(name: 'D', octave: 3, frequency: 146.83),
        StringTuning(name: 'G', octave: 3, frequency: 196.0),
        StringTuning(name: 'B', octave: 3, frequency: 246.94),
        StringTuning(name: 'D', octave: 4, frequency: 293.66),
      ],
    ),
    InstrumentTuning(
      id: 'guitar',
      name: 'Gitar',
      icon: '🎸',
      tuningName: 'DADGAD',
      strings: [
        StringTuning(name: 'D', octave: 2, frequency: 73.42),
        StringTuning(name: 'A', octave: 2, frequency: 110.0),
        StringTuning(name: 'D', octave: 3, frequency: 146.83),
        StringTuning(name: 'G', octave: 3, frequency: 196.0),
        StringTuning(name: 'A', octave: 3, frequency: 220.0),
        StringTuning(name: 'D', octave: 4, frequency: 293.66),
      ],
    ),
    InstrumentTuning(
      id: 'guitar',
      name: 'Gitar',
      icon: '🎸',
      tuningName: 'Half Step Down',
      strings: [
        StringTuning(name: 'D#', octave: 2, frequency: 77.78),
        StringTuning(name: 'G#', octave: 2, frequency: 103.83),
        StringTuning(name: 'C#', octave: 3, frequency: 138.59),
        StringTuning(name: 'F#', octave: 3, frequency: 185.0),
        StringTuning(name: 'A#', octave: 3, frequency: 233.08),
        StringTuning(name: 'D#', octave: 4, frequency: 311.13),
      ],
    ),
    InstrumentTuning(
      id: 'guitar',
      name: 'Gitar',
      icon: '🎸',
      tuningName: 'Open D',
      strings: [
        StringTuning(name: 'D', octave: 2, frequency: 73.42),
        StringTuning(name: 'A', octave: 2, frequency: 110.0),
        StringTuning(name: 'D', octave: 3, frequency: 146.83),
        StringTuning(name: 'F#', octave: 3, frequency: 185.0),
        StringTuning(name: 'A', octave: 3, frequency: 220.0),
        StringTuning(name: 'D', octave: 4, frequency: 293.66),
      ],
    ),
  ],

  // --- Bas Gitar ---
  'bass_guitar': [
    InstrumentTuning(
      id: 'bass_guitar',
      name: 'Bas Gitar',
      icon: '🎸',
      tuningName: 'Drop D',
      strings: [
        StringTuning(name: 'D', octave: 1, frequency: 36.71),
        StringTuning(name: 'A', octave: 1, frequency: 55.0),
        StringTuning(name: 'D', octave: 2, frequency: 73.42),
        StringTuning(name: 'G', octave: 2, frequency: 98.0),
      ],
    ),
    InstrumentTuning(
      id: 'bass_guitar',
      name: 'Bas Gitar',
      icon: '🎸',
      tuningName: 'Half Step Down',
      strings: [
        StringTuning(name: 'D#', octave: 1, frequency: 38.89),
        StringTuning(name: 'G#', octave: 1, frequency: 51.91),
        StringTuning(name: 'C#', octave: 2, frequency: 69.30),
        StringTuning(name: 'F#', octave: 2, frequency: 92.50),
      ],
    ),
  ],

  // --- Bağlama ---
  'baglama': [
    InstrumentTuning(
      id: 'baglama',
      name: 'Bağlama',
      icon: '🪕',
      tuningName: 'Bozuk Düzen',
      strings: [
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'Re', octave: 3, frequency: 146.83),
        StringTuning(name: 'Re', octave: 3, frequency: 146.83),
        StringTuning(name: 'Mi', octave: 3, frequency: 164.81),
        StringTuning(name: 'Mi', octave: 3, frequency: 164.81),
        StringTuning(name: 'Mi', octave: 4, frequency: 329.63),
      ],
    ),
    InstrumentTuning(
      id: 'baglama',
      name: 'Bağlama',
      icon: '🪕',
      tuningName: 'Misket Düzeni',
      strings: [
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'Mi', octave: 3, frequency: 164.81),
        StringTuning(name: 'Mi', octave: 3, frequency: 164.81),
        StringTuning(name: 'La', octave: 3, frequency: 220.0),
        StringTuning(name: 'La', octave: 3, frequency: 220.0),
        StringTuning(name: 'La', octave: 4, frequency: 440.0),
      ],
    ),
    InstrumentTuning(
      id: 'baglama',
      name: 'Bağlama',
      icon: '🪕',
      tuningName: 'Müstezat Düzeni',
      strings: [
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'La', octave: 2, frequency: 110.0),
        StringTuning(name: 'Re', octave: 3, frequency: 146.83),
        StringTuning(name: 'Re', octave: 3, frequency: 146.83),
        StringTuning(name: 'La', octave: 3, frequency: 220.0),
        StringTuning(name: 'La', octave: 3, frequency: 220.0),
        StringTuning(name: 'La', octave: 4, frequency: 440.0),
      ],
    ),
  ],

  // --- Ukulele ---
  'ukulele': [
    InstrumentTuning(
      id: 'ukulele',
      name: 'Ukulele',
      icon: '🪕',
      tuningName: 'Low G',
      strings: [
        StringTuning(name: 'G', octave: 3, frequency: 196.0),
        StringTuning(name: 'C', octave: 4, frequency: 261.63),
        StringTuning(name: 'E', octave: 4, frequency: 329.63),
        StringTuning(name: 'A', octave: 4, frequency: 440.0),
      ],
    ),
    InstrumentTuning(
      id: 'ukulele',
      name: 'Ukulele',
      icon: '🪕',
      tuningName: 'D Tuning',
      strings: [
        StringTuning(name: 'A', octave: 4, frequency: 440.0),
        StringTuning(name: 'D', octave: 4, frequency: 293.66),
        StringTuning(name: 'F#', octave: 4, frequency: 369.99),
        StringTuning(name: 'B', octave: 4, frequency: 493.88),
      ],
    ),
  ],
};
