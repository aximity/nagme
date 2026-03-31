class StringTuning {
  const StringTuning({
    required this.name,
    required this.noteName,
    required this.octave,
    required this.frequency,
  });

  final String name;       // "G3", "D4", "A4", "E5"
  final String noteName;   // "G", "D", "A", "E"
  final int octave;        // 3, 4, 4, 5
  final double frequency;  // 196.0, 293.7, 440.0, 659.3
}

class InstrumentTuning {
  const InstrumentTuning({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.strings,
    this.visible = true,
  });

  final String id;                    // "violin"
  final String name;                  // "Keman"
  final String nameEn;                // "Violin"
  final String icon;                  // emoji veya asset yolu
  final List<StringTuning> strings;
  final bool visible;                 // false → UI'da gizli, kod hazır

  bool get isChromatic => strings.isEmpty;
}
