/// Algılanan nota bilgisi
class Note {
  final String name;
  final int octave;
  final double frequency;
  final double cents;

  const Note({
    required this.name,
    required this.octave,
    required this.frequency,
    required this.cents,
  });

  String get fullName => '$name$octave';

  bool isInTune(double threshold) => cents.abs() <= threshold;
}
