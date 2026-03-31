import 'package:nagme/models/instrument.dart';

const List<InstrumentTuning> kInstruments = [
  // ═══════════════════════════════════════════
  // GÖRÜNÜR — Kıbrıs Sanat Müzik Bölümü
  // ═══════════════════════════════════════════

  // Kromatik (enstrümansız mod — Vokal dahil tüm enstrümanlar için)
  InstrumentTuning(
    id: 'chromatic',
    name: 'Kromatik',
    nameEn: 'Chromatic',
    icon: '🎵',
    strings: [],
  ),

  // Keman
  InstrumentTuning(
    id: 'violin',
    name: 'Keman',
    nameEn: 'Violin',
    icon: '🎻',
    strings: [
      StringTuning(name: 'G3', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'D4', noteName: 'D', octave: 4, frequency: 293.7),
      StringTuning(name: 'A4', noteName: 'A', octave: 4, frequency: 440.0),
      StringTuning(name: 'E5', noteName: 'E', octave: 5, frequency: 659.3),
    ],
  ),

  // Viyolonsel (Çello)
  InstrumentTuning(
    id: 'cello',
    name: 'Viyolonsel',
    nameEn: 'Cello',
    icon: '🎻',
    strings: [
      StringTuning(name: 'C2', noteName: 'C', octave: 2, frequency: 65.4),
      StringTuning(name: 'G2', noteName: 'G', octave: 2, frequency: 98.0),
      StringTuning(name: 'D3', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'A3', noteName: 'A', octave: 3, frequency: 220.0),
    ],
  ),

  // Trompet (Bb) — açık pozisyon notaları
  InstrumentTuning(
    id: 'trumpet',
    name: 'Trompet',
    nameEn: 'Trumpet',
    icon: '🎺',
    strings: [
      StringTuning(name: 'Bb3', noteName: 'Bb', octave: 3, frequency: 233.1),
      StringTuning(name: 'F4', noteName: 'F', octave: 4, frequency: 349.2),
      StringTuning(name: 'Bb4', noteName: 'Bb', octave: 4, frequency: 466.2),
    ],
  ),

  // Trombon (Bb) — açık pozisyon notaları
  InstrumentTuning(
    id: 'trombone',
    name: 'Trombon',
    nameEn: 'Trombone',
    icon: '🎵',
    strings: [
      StringTuning(name: 'Bb2', noteName: 'Bb', octave: 2, frequency: 116.5),
      StringTuning(name: 'F3', noteName: 'F', octave: 3, frequency: 174.6),
      StringTuning(name: 'Bb3', noteName: 'Bb', octave: 3, frequency: 233.1),
    ],
  ),

  // Korno (French Horn, F) — açık pozisyon notaları
  InstrumentTuning(
    id: 'french_horn',
    name: 'Korno',
    nameEn: 'French Horn',
    icon: '🎵',
    strings: [
      StringTuning(name: 'F3', noteName: 'F', octave: 3, frequency: 174.6),
      StringTuning(name: 'C4', noteName: 'C', octave: 4, frequency: 261.6),
      StringTuning(name: 'F4', noteName: 'F', octave: 4, frequency: 349.2),
    ],
  ),

  // Tuba (Bb) — açık pozisyon notaları
  InstrumentTuning(
    id: 'tuba',
    name: 'Tuba',
    nameEn: 'Tuba',
    icon: '🎵',
    strings: [
      StringTuning(name: 'Bb1', noteName: 'Bb', octave: 1, frequency: 58.3),
      StringTuning(name: 'F2', noteName: 'F', octave: 2, frequency: 87.3),
      StringTuning(name: 'Bb2', noteName: 'Bb', octave: 2, frequency: 116.5),
    ],
  ),

  // ═══════════════════════════════════════════
  // GİZLİ — İleride aktif edilecek enstrümanlar
  // ═══════════════════════════════════════════

  // Gitar
  InstrumentTuning(
    id: 'guitar',
    name: 'Gitar',
    nameEn: 'Guitar',
    icon: '🎸',
    visible: false,
    strings: [
      StringTuning(name: 'E2', noteName: 'E', octave: 2, frequency: 82.4),
      StringTuning(name: 'A2', noteName: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'D3', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'G3', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'B3', noteName: 'B', octave: 3, frequency: 246.9),
      StringTuning(name: 'E4', noteName: 'E', octave: 4, frequency: 329.6),
    ],
  ),

  // Bas Gitar
  InstrumentTuning(
    id: 'bass',
    name: 'Bas Gitar',
    nameEn: 'Bass Guitar',
    icon: '🎸',
    visible: false,
    strings: [
      StringTuning(name: 'E1', noteName: 'E', octave: 1, frequency: 41.2),
      StringTuning(name: 'A1', noteName: 'A', octave: 1, frequency: 55.0),
      StringTuning(name: 'D2', noteName: 'D', octave: 2, frequency: 73.4),
      StringTuning(name: 'G2', noteName: 'G', octave: 2, frequency: 98.0),
    ],
  ),

  // Ukulele
  InstrumentTuning(
    id: 'ukulele',
    name: 'Ukulele',
    nameEn: 'Ukulele',
    icon: '🪕',
    visible: false,
    strings: [
      StringTuning(name: 'G4', noteName: 'G', octave: 4, frequency: 392.0),
      StringTuning(name: 'C4', noteName: 'C', octave: 4, frequency: 261.6),
      StringTuning(name: 'E4', noteName: 'E', octave: 4, frequency: 329.6),
      StringTuning(name: 'A4', noteName: 'A', octave: 4, frequency: 440.0),
    ],
  ),

  // Bağlama
  InstrumentTuning(
    id: 'baglama',
    name: 'Bağlama',
    nameEn: 'Baglama',
    icon: '🎵',
    visible: false,
    strings: [
      StringTuning(name: 'La2', noteName: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'La2b', noteName: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'Re3', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'Re3b', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'Sol3', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'Sol3b', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'Sol4', noteName: 'G', octave: 4, frequency: 392.0),
    ],
  ),

  // Ud
  InstrumentTuning(
    id: 'oud',
    name: 'Ud',
    nameEn: 'Oud',
    icon: '🎵',
    visible: false,
    strings: [
      StringTuning(name: 'Yeg1', noteName: 'D', octave: 2, frequency: 73.4),
      StringTuning(name: 'Yeg2', noteName: 'D', octave: 2, frequency: 73.4),
      StringTuning(name: 'Aşi1', noteName: 'G', octave: 2, frequency: 98.0),
      StringTuning(name: 'Aşi2', noteName: 'G', octave: 2, frequency: 98.0),
      StringTuning(name: 'Rast1', noteName: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'Rast2', noteName: 'A', octave: 2, frequency: 110.0),
      StringTuning(name: 'Düg1', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'Düg2', noteName: 'D', octave: 3, frequency: 146.8),
      StringTuning(name: 'Nev1', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'Nev2', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'Bam', noteName: 'C', octave: 3, frequency: 130.8),
    ],
  ),

  // Viyola
  InstrumentTuning(
    id: 'viola',
    name: 'Viyola',
    nameEn: 'Viola',
    icon: '🎻',
    visible: false,
    strings: [
      StringTuning(name: 'C3', noteName: 'C', octave: 3, frequency: 130.8),
      StringTuning(name: 'G3', noteName: 'G', octave: 3, frequency: 196.0),
      StringTuning(name: 'D4', noteName: 'D', octave: 4, frequency: 293.7),
      StringTuning(name: 'A4', noteName: 'A', octave: 4, frequency: 440.0),
    ],
  ),
];
