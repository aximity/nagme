class PitchResult {
  final double frequency;
  final double confidence;
  final DateTime timestamp;

  const PitchResult({
    required this.frequency,
    required this.confidence,
    required this.timestamp,
  });

  bool get isValid => frequency > 0 && confidence > 0.5;

  @override
  String toString() =>
      'PitchResult(freq: ${frequency.toStringAsFixed(1)} Hz, conf: ${confidence.toStringAsFixed(2)})';
}
