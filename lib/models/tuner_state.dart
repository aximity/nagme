enum TunerStatus { idle, flat, sharp, inTune }

enum NoteNotation { letter, solfege }

enum SoundType { sine, square, triangle }

class TunerState {
  final TunerStatus status;
  final String note;
  final int octave;
  final double frequency;
  final double cents;

  const TunerState({
    this.status = TunerStatus.idle,
    this.note = '--',
    this.octave = 0,
    this.frequency = 0,
    this.cents = 0,
  });

  String get noteDisplay => status == TunerStatus.idle ? '--' : '$note$octave';
  String get frequencyDisplay =>
      status == TunerStatus.idle ? '--- Hz' : '${frequency.toStringAsFixed(1)} Hz';
  String get centsDisplay {
    if (status == TunerStatus.idle) return '±0 cent';
    final sign = cents >= 0 ? '+' : '';
    return '$sign${cents.round()} cent';
  }
  String get statusText {
    switch (status) {
      case TunerStatus.idle:
        return '';
      case TunerStatus.flat:
        return 'TUNE UP ↑';
      case TunerStatus.sharp:
        return 'TUNE DOWN ↓';
      case TunerStatus.inTune:
        return 'PERFECT ✓';
    }
  }
}
