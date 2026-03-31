class Note {
  const Note({
    required this.name,
    required this.octave,
    required this.frequency,
    required this.cents,
  });

  final String name;       // "A", "C#", "Gb"
  final int octave;        // 0–8
  final double frequency;  // Hz (tespit edilen)
  final double cents;      // -50 ile +50 arası

  String get fullName => '$name$octave'; // "A4"

  bool isInTune(int threshold) => cents.abs() <= threshold;

  @override
  String toString() => 'Note($fullName, ${cents.toStringAsFixed(1)}¢)';
}
