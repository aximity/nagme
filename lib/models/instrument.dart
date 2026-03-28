/// Tek bir tel akort tanımı
class StringTuning {
  final String name;
  final int octave;
  final double frequency;

  const StringTuning({
    required this.name,
    required this.octave,
    required this.frequency,
  });

  String get fullName => '$name$octave';
}

/// Enstrüman akort tanımı
class InstrumentTuning {
  final String id;
  final String name;
  final String icon;
  final List<StringTuning> strings;
  final String tuningName;

  const InstrumentTuning({
    required this.id,
    required this.name,
    required this.icon,
    required this.strings,
    this.tuningName = 'Standart',
  });

  /// Asset yolu: assets/instruments/{id}.png
  String get iconAsset => 'assets/instruments/$id.png';

  int get stringCount => strings.length;
  bool get isChromatic => strings.isEmpty;
}
